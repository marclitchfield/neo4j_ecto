defmodule Neo4j.Ecto do
  @behaviour Ecto.Adapter
  alias Neo4j.Sips, as: Neo4j

  defmacro __before_compile__(_env) do
  end

  def start_link(_name, _opts) do
    # This is probably not the right way to do this. Need to figure out how
    # to properly manage the lifetime of these required processes.
    {:ok, _} = Application.ensure_all_started(:hackney)
    {:ok, _} = Application.ensure_all_started(:con_cache)
    Neo4j.start(Neo4j.Sips, [])
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

  def execute(_repo, _meta, {_function, query}, params, _preprocess, opts) do
    {:ok, []}
  end

  require IEx
  def insert(repo, meta, fields, autogenerate_id, returning, options) do
    # TODO: scrub label to guard against injection. Cannot parameterize labels in Cypher.
    label = meta[:source] |> elem(1)
    title = fields[:title]
    Neo4j.query(Neo4j.conn, "CREATE (n:#{label} {title:{title}})", %{title: title})
  end

  def update(_repo, _meta, _fields, _filter, _autogenerate, _returning, _opts) do
    {:ok, []}
  end

  def delete(_repo, _meta, _filter, _autogenarate, _opts) do
    {:ok, []}
  end

end
