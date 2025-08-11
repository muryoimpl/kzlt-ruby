# frozen_string_literal: true

require "erd_mermaid"

namespace :db do
  desc "export mermaid erd"
  task export_relations_to_mermaid: :environment do
    hash = ErdMermaid::ModelLoader.load
    config = ErdMermaid::Config.new
    ErdMermaid::GroupsErDiagramOutput.new(config, hash).execute
  end

  desc "check typo"
  task check!: :environment do
    config = ErdMermaid::Config.new
    ErdMermaid::ModelLoader.check!(config)
  end
end
