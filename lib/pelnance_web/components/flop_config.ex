defmodule PelnanceWeb.FlopConfig do
  def pagination_opts do
    [
      page_links: {:ellipsis, 5},
      disabled_class: "disabled opacity-50",
      wrapper_attrs: [
        class: "text-center mt-4 flex"
      ],
      previous_link_content: Phoenix.HTML.raw("< Previous"),
      previous_link_attrs: [
        class: "p-2 mr-2 border-2 btn rounded-md border-base-300"
      ],
      pagination_list_attrs: [
        class: "flex order-2 place-items-center gap-4 px-4"
      ],
      next_link_content: Phoenix.HTML.raw("Next >"),
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
      container_attrs: [class: "overflow-y-auto px-4 sm:overflow-visible sm:px-0"],
      table_attrs: [class: "w-full mt-11 sm:w-full"],
      thead_attrs: [class: "text-sm text-left leading-6 text-zinc-500"],
      tbody_td_attrs: [class: "relative w-14 p-0"]
    ]
  end
end
