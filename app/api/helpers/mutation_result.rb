module Helpers::MutationResult
  def render_mutation_result(outcome, status_only: false)
    if outcome.success?
      if status_only
        { status: :ok }
      else
        { status: :ok, result: outcome.result }
      end
    else
      status 422
      { status: :error, error: outcome.errors.message }
    end
  end
end
