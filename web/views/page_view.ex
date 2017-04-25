defmodule Hnet.PageView do
  use Hnet.Web, :view

  def greeting(user) do
    content_tag(:p, "Hi there, #{user.first_name} #{user.last_name}!", class: "lead")
  end
end
