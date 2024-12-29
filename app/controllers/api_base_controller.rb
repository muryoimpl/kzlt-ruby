# frozen_string_literal: true

class ApiBaseController < ApplicationController
  include SlackRequestVerification
  include SlackRequestFilter
end
