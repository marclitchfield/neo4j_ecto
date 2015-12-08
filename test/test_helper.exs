Logger.configure(level: :info)
ExUnit.start exclude: [:uses_usec, :id_type, :read_after_writes, :sql_fragments, :decimal_type, :invalid_prefix, :transaction, :foreign_key_constraint]

Application.put_env(:ecto, :primary_key_type, :id)

Code.require_file "../deps/ecto/integration_test/support/repo.exs", __DIR__
Code.require_file "../deps/ecto/integration_test/support/models.exs", __DIR__

alias Ecto.Integration.TestRepo

Application.put_env(:ecto, TestRepo,
                    adapter: Neo4j.Ecto,
                    url: "ecto://localhost:7474/ecto_test",
                    pool_size: 1)

defmodule Ecto.Integration.TestRepo do
  use Ecto.Integration.Repo, otp_app: :ecto
end

defmodule Ecto.Integration.Case do
  use ExUnit.CaseTemplate

  alias Ecto.Integration.TestRepo
end

{:ok, _pid} = TestRepo.start_link
