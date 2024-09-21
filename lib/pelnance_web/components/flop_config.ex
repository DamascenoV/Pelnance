defmodule PelnanceWeb.FlopConfig do
  def pagination_opts do
    [
      page_links: {:ellipsis, 5},
      disabled_class: "disabled opacity-50",
      wrapper_attrs: [
        class: "text-center mt-4 flex"
      ],
      previous_link_content: Phoenix.HTML.raw(Gettext.gettext(PelnanceWeb.Gettext, "< Previous")),
      previous_link_attrs: [
        class: "p-2 mr-2 border-2 btn rounded-md border-base-300"
      ],
      pagination_list_attrs: [
        class: "flex order-2 place-items-center gap-4 px-4"
      ],
      next_link_content: Phoenix.HTML.raw(Gettext.gettext(PelnanceWeb.Gettext, "Next >")),
      next_link_attrs: [
        class: "p-2 ml-2 border-2 btn rounded-md order-3 border-base-300"
      ],
      current_link_attrs: [
        class: "text-success"
      ]
    ]
  end

  def table_opts do
    [
        table_attrs: [class: "table table-sm table-zebra"],
        tbody_td_attrs: [class: "cursor-pointer"]
    ]
  end
end
