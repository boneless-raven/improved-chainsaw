defmodule Mix.Tasks.Hnet.CreateAdmin do
  use Mix.Task
  
  alias Hnet.Repo
  alias Hnet.Hospital
  alias Hnet.Account.Registration

  import Phoenix.Naming

  @shortdoc "Create an administrator account"

  def run(_) do
    Application.ensure_all_started(:hnet)

    {first_name, last_name} = prompt("full name") |> split_name
    email = prompt("email")
    phone = prompt("phone")
    address = prompt("address")
    gender = get_gender()
    username = prompt("username")
    password = prompt("password")
    password_confirmation = prompt("password_confirmation")
    hospital_id = get_hospital_id()

    params = %{first_name: first_name, last_name: last_name, email: email,
               phone: phone, address: address, gender: gender, username: username,
               password: password, password_confirmation: password_confirmation,
               administrator: %{hospital_id: hospital_id}}
    changeset = Registration.new_administrator(params)
    
    case Repo.insert(changeset) do
      {:ok, _} ->
        Mix.shell.info("Successfully created admin account: #{username}")
      {:error, changeset} ->
        Mix.shell.error("Failed to create account")
        output_errors(changeset)
    end
  end

  defp output_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.each(fn {field_name, msgs} ->
      Mix.shell.info("#{humanize(field_name)}: #{inspect(msgs)}")
    end)
  end

  defp prompt(field_name) do
    Mix.shell.prompt("Please enter the #{field_name}: ")
  end

  defp split_name(full_name) do
    parts = String.split(full_name, " ", parts: 2, trim: true)
    {List.first(parts), List.last(parts)}
  end

  defp get_gender do
    case "gender (male | female)" |> prompt |> String.trim |> String.downcase |> cast_gender do
      nil -> get_gender()
      gender -> gender
    end
  end

  defp cast_gender("male"), do: :male
  defp cast_gender("female"), do: :female
  defp cast_gender(input) do
    IO.inspect input
    nil
  end

  defp get_hospital_id do
    Mix.shell.info("Available hospitals:")
    Repo.all(Hospital) |> Enum.each(fn h -> Mix.shell.info("#{h.id} -> #{h.name}") end)
    prompt_for_hospital_id()
  end

  defp prompt_for_hospital_id do
    case "hospital (id)" |> prompt |> String.trim |> Integer.parse |> check_hospital_id do
      nil -> prompt_for_hospital_id()
      id -> id
    end
  end

  defp check_hospital_id({id, _}) do
    case Repo.get(Hospital, id) do
      nil -> nil
      hospital -> hospital.id
    end
  end

  defp check_hospital_id(:error), do: nil
end