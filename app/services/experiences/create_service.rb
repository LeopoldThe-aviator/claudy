module Experiences
  class CreateService < ServiceBase
    attr_reader :experience

    def initialize
      @experience = Experience.new
      @report_errors = true
    end

    def run(params = {})
      context = {
        params: params,
      }

      catch_error(context: context) do
        run!(params)
      end
    end

    def run!(params = {})
      experience.attributes = experience_params(params)
      experience.save!
      true
    end

    private

    def experience_params(params)
      params
        .require(:experience)
        .permit(
          :name,
          :human_id,
          :summary,
          :description,
          :price,
          :photo,
          :photo_cache
        )
    end
  end
end
