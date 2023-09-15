defmodule Kotkowo.Cats do
  alias Kotkowo.Cats.Cat

  def cat_get(id) do
    with {:ok, %{"data" => %{"cat" => data}}} <-
           Strapi.query(
             """
               query ($id: ID){
                 cat(id: $id){
                   data{
                     id,
                     attributes {
                       name
                       sex
                       seniority
                       health
                       castrated
                       fiv_felv_passed
                       createdAt
                       updatedAt
                     }
                   }
                 }
               }
             """,
             %{"id" => id}
           ) do
      Cat.parse(data)
    end
  end
end
