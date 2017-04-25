defmodule Hnet.FormHelpers do
  @moduledoc """
  Conveniences for building form fields from changesets.
  """

  use Phoenix.HTML
  import Hnet.ErrorHelpers

  @doc """
  Generates a form group for the given form and field.
  The form group will contain a label and an input field.
  If there's any error associated with the given field,
  there will also be an error label,
  and the form group will have the "has-error" class.

  Supported options are: 
  `:label_opts`, `:input_type`, `:input_opts` and `:group_opts`.
  """
  def form_group(form, field, opts \\ []) do
    params = {form, field, opts}

    label = make_label(params)
    input = make_input(params)
    error_label = error_tag(form, field)

    make_group(label, input, error_label, opts)
  end

  defp make_label({form, field, opts}) do
    label_opts = Keyword.get(opts, :label_opts, []) |> add_class("control-label")
    label(form, field, label_opts)
  end
  
  defp make_input({form, field, opts}) do
    input_opts = Keyword.get(opts, :input_opts, []) |> add_class("form-control")
    type = Keyword.get(opts, :input_type) || input_type(form, field)
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
  
  defp make_group(label, input, error_label, opts) do
    group_class = form_group_class(error_label)
    group_opts = Keyword.get(opts, :group_opts, []) |> add_class(group_class)
    content_tag(:div, [label, input, error_label || ""], group_opts)
  end

  defp form_group_class(nil) do
    "form-group"
  end

  defp form_group_class(_error_label) do
    "form-group has-error"
  end

  def add_class(opts, class) do
    Keyword.put(opts, :class, "#{Keyword.get(opts, :class, "")} #{class}")
  end
end