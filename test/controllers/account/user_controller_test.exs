# defmodule Hnet.UserControllerTest do
#   use Hnet.ConnCase

#   import Hnet.DefaultModels

#   @valid_attrs %{
#     address: "Somewhere", phone: "1230984576", gender: "female",
#     first_name: "Arya", last_name: "Stark", email: "arya.stark@mail.com",
#     patient: %{
#       primary_doctor_id: nil,
#       proof_of_insurance: "Death is whimsical today.",
#       emergency_contact_name: "God of a thousand faces",
#       emergency_contact_phone: "0128934567"
#     }
#   }
#   @invalid_attrs %{}

#   test "change patient profile with valid changes", %{conn: conn} do
#     create_default_hospital()
#     create_default_doctor()
#     user = create_default_patient()

#     conn
#     |> login(user.id)
#     |> 
#   end
# end
