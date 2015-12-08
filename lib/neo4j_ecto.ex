defmodule Neo4j.Ecto do
  @behaviour Ecto.Adapter

  defmacro __before_compile__(_env) do
  end

  def start_link(_name, _opts) do
    {:ok, _} = Application.ensure_all_started(:hackney)
    {:ok, _} = Application.ensure_all_started(:con_cache)
    Neo4j.Sips.start(Neo4j.Sips, [])
  end

  def stop(_pid, _timeout) do
    :ok
  end

  def load(type, data) do
    Ecto.Type.load(type, data, &load/2)
  end

  def dump(type, data) do
    Ecto.Type.dump(type, data, &dump/2)
  end

  def embed_id(_), do: nil

  def prepare(function, query) do
    {:nocache, {function, query}}
  end

  def execute(_repo, _meta, {_function, _query}, _params, _preprocess, _opts) do
    {:ok, nil}
  end

  def insert(_repo, _meta, _params, nil, [], _opts) do
    {:ok, []}
  end

  def update(_repo, _meta, _fields, _filter, _autogenerate, _returning, _opts) do
    {:ok, []}
  end

  def delete(_repo, _meta, _filter, _autogenarate, _opts) do
    {:ok, []}
  end

end
