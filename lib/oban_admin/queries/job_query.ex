defmodule ObanAdmin.Queries.JobQuery do
  alias ObanAdmin.Schemas.Job
  alias ObanAdmin.Repo
  import Ecto.Query

  def all() do
    base()
    |> Repo.all()
  end

  def update(%Job{} = model, attrs) do
    model
    |> Job.update_changeset(attrs)
    |> Repo.update()
  end

  def update!(%Job{} = model, attrs) do
    model
    |> Job.update_changeset(attrs)
    |> Repo.update!()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def delete_all() do
    base()
    |> Repo.delete_all()
  end

  def search(value) when is_binary(value) do
    search_for = "%#{value}%"

    base()
    |> where(
      [u],
      ilike(u.email, ^search_for) or
        ilike(u.first_name, ^search_for) or
        ilike(u.last_name, ^search_for)
    )
    |> Repo.all()
  end

  def base, do: from(Job, as: :job)
end
