# frozen_string_literal: true

require "yaml"

# 設定: erd_mermaid.yml
# ```yaml
# groups:
#   企業:
#     - organizations
#     - ...
#   非同期処理:
#     - ...
# ignored_groups:
#   - 非同期処理
# ```
# 使用例
# hash = ErdMermaid::ModelLoader.load
# config = ErdMermaid::Config.new
# ErdMermaid::GroupsErDiagramOutput.new(config, hash).execute
module ErdMermaid
  I18N_ATTRIBUTE_SCOPE = "activerecord.attributes.erd"

  class Config
    def initialize = @config = YAML.load_file(Rails.root.join("erd_mermaid.yml"))
    def groups = @config["groups"]
    def ignored_groups = @config["ignored_groups"]
    def ignored_tables = @config["ignored_tables"]
  end

  class ModelLoader
    class << self
      def load
        load_model_classes!

        hash = { tables: [], relations: {} }

        application_record_descendants.each_with_object(hash) do |klass, acc|
          acc[:tables] << ModelInformationCollector.new(klass)

          relation_collector = RelationCollector.new(klass)
          relation_collector.collect_relations

          acc[:relations][klass.table_name] = relation_collector
        end
      end

      def check!(config)
        load_model_classes!

        table_names = application_record_descendants.map(&:table_name).uniq
        groups = config.groups.reject { |group| config.ignored_groups.include?(group) }
        unknown = groups.values.flatten.uniq - (table_names + config.ignored_tables)

        raise "Unknown table names exist in erd_mermaid.yml: #{unknown.join(',')}" if unknown.present?

        Rails.logger.info "all table names in erd_mermaid.yml are in database"
      end

      private

      def application_record_descendants
        ApplicationRecord.descendants.filter(&:base_class?).sort_by(&:name)
      end

      def load_model_classes!
        Rails.autoloaders.main.eager_load_dir(Rails.root.join("app/models"))
      end
    end
  end

  class GroupsErDiagramOutput
    attr_reader :config, :collected_hash

    def initialize(config, collected_hash)
      @config = config
      @collected_hash = collected_hash
    end

    def execute
      config.groups.each do |group_name, grouped_table_names|
        next if config.ignored_groups.include?(group_name)

        model_texts = ModelTextBuilder.build(collected_hash[:tables], grouped_table_names)
        relation_texts = RelationTextBuilder.build(collected_hash[:relations], grouped_table_names)

        mermaid_text = <<~TEXT
          erDiagram

          #{model_texts}
          #{relation_texts}
        TEXT

        Rails.root.join("erd_#{group_name}.md").write(mermaid_text)
      end
    end

    class TextBuilderBase
      private

      def double_quoted(str) = "\"#{str}\""
      def translate(key, scope:) = I18n.t(key, scope:, locale: :ja, default: "")
    end

    class ModelTextBuilder < TextBuilderBase
      class << self
        def select(model_collectors, grouped_table_names)
          model_collectors.select { |collector| grouped_table_names.include?(collector.table_name) }
        end

        def build(model_collectors, grouped_table_names)
          select(model_collectors, grouped_table_names).map { |collector| new(collector).text }.join("\n")
        end
      end

      attr_reader :collector

      def initialize(collector)
        super()
        @collector = collector
      end

      def text
        attribute_lines = collector.attributes.values.map { |attr| "  #{attribute_line(attr)}" }.join("\n")

        <<~TEXT
          #{model_name} {
          #{attribute_lines}
          }
        TEXT
      end

      private

      def attribute_line(attr)
        "#{attr[:type]} #{attr[:name]} #{double_quoted(attr[:name_ja])}".strip
      end

      def model_name
        if collector.name_ja.present?
          double_quoted("#{collector.table_name}: #{collector.name_ja}")
        else
          collector.table_name
        end
      end
    end

    class RelationTextBuilder < TextBuilderBase
      class << self
        def select(relations, table_names)
          relations.select do |relation|
            table_names.include?(relation.right) &&
              !relation.belongs_to? && # simple にするため
              !relation.through?       # simple にするため
          end
        end

        def build(relation_collectors_hash, table_names)
          table_names.filter_map do |table_name|
            relation_collector = relation_collectors_hash[table_name]

            next unless relation_collector

            selected_relations = select(relation_collector.relations, table_names)
            next if selected_relations.blank?

            selected_relations.map { |relation| RelationTextBuilder.new(relation).text }
          end.flatten.join("\n")
        end
      end

      attr_reader :relation

      def initialize(relation)
        super()
        @relation = relation
      end

      # |Value (left) | Value (right) | Meaning                       |
      # | ----------- | ------------- | -------------------------------
      # | |o          | o|            | Zero or one                   |
      # | ||          | ||            | Exactly one                   |
      # | }o          | o{            | Zero or more (no upper limit) |
      # | }|          | |{            | One or more (no upper limit)  |
      def left_mark
        if relation.has_many? || relation.has_one?
          relation.through? ? "}o" : "||"
        elsif relation.belongs_to?
          "}o"
        end
      end

      def right_mark
        if relation.has_many?
          "o{"
        elsif relation.has_one?
          "o|"
        elsif relation.belongs_to?
          "||"
        end
      end

      def arrow
        relation.through? ? ".." : "--"
      end

      def relationship_label
        double_quoted("")
      end

      def text
        [
          double_quoted(relation.left_with_ja),
          "#{left_mark}#{arrow}#{right_mark}",
          "#{double_quoted(relation.right_with_ja)} : #{relationship_label}"
        ].join(" ")
      end
    end
  end

  class Collector
    attr_reader :klass

    def initialize(klass) = @klass = klass
    delegate :table_name, to: :@klass

    private

    def translate(key, scope:) = I18n.t(key, scope:, locale: :ja, default: "")
  end

  class ModelInformationCollector < Collector
    delegate :name, to: :klass

    def name_ja
      str = translate(klass.name.underscore, scope: "activerecord.models")
      str.presence || ""
    end

    def attributes
      @attributes ||= klass.columns.each_with_object({}) do |column, acc|
        acc[column.name] = {
          name: column.name,
          comment: column.comment,
          name_ja: translate(column.name, scope: [ I18N_ATTRIBUTE_SCOPE, klass.name.underscore ]),
          type: column.type
        }
      end
    end
  end

  class RelationCollector < Collector
    attr_reader :relations

    def left_name
      table_name
    end

    def right_name(reflection) = reflection.table_name

    def collect_relations
      @relations = @klass.reflections.values.filter_map do |reflection|
        if reflection.is_a?(::ActiveRecord::Reflection::HasAndBelongsToManyReflection)
          raise "has_and_belongs_to_many はまだ想定していない"
        end

        next if reflection.is_a?(::ActiveRecord::Reflection::ThroughReflection)
        next if reflection.is_a?(::ActiveRecord::Reflection::BelongsToReflection)

        Relation.new(left: left_name, right: right_name(reflection), klass:, reflection:)
      end
    end
  end

  Relation = Data.define(:left, :right, :klass, :reflection) do
    def table_name = left

    def relation
      case reflection
      when ::ActiveRecord::Reflection::HasManyReflection
        :has_many
      when ::ActiveRecord::Reflection::HasOneReflection
        :has_one
      when ::ActiveRecord::Reflection::BelongsToReflection
        :belongs_to
      when ::ActiveRecord::Reflection::ThroughReflection
        case reflection.through_reflection
        when ::ActiveRecord::Reflection::HasManyReflection
          :has_many
        when ::ActiveRecord::Reflection::HasOneReflection
          :has_one
        end
      end
    end

    def has_many? = relation == :has_many
    def has_one? = relation == :has_one
    def belongs_to? = relation == :belongs_to
    def through? = !!reflection.options[:through]

    def left_with_ja
      klass_name_ja = translate(klass.name.underscore, scope: "activerecord.models")
      klass_name_ja.present? ? "#{left}: #{klass_name_ja}" : left
    end

    def right_with_ja
      right_klass_name_ja = translate(reflection.klass.name.underscore, scope: "activerecord.models")
      right_klass_name_ja.present? ? "#{right}: #{right_klass_name_ja}" : right
    end

    private

    def translate(key, scope:) = I18n.t(key, scope:, locale: :ja, default: "")
  end
end
