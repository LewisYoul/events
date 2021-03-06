class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Context

  def text_field_with_icon(method, options = {})
    raw(
      <<-HTML
        <div class="relative">
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
          #{text_field(method, options)}
        </div>
      HTML
    )
  end

  def multi_select(method, choices, selected_choices, options = {}, html_options = {}, &block)
    multi_select_input = select(method, options_from_collection_for_select(choices, :id, :full_name, selected_choices), options, html_options, &block)
    
    choices = choices.map do |choice|
      selected = selected_choices.include?(choice)

      <<-HTML
        <div data-action='click->multiselect#toggleSelection' data-multiselect-target='option' data-selected='#{selected}' class="flex items-center pr-4 pl-1 px-3 py-2 hover:bg-green-50 #{'bg-green-50' if selected}">
          <span data-multiselect-target="spacer" class="h-4 w-4 mr-1 #{'hidden' if selected}"></span>
          <svg data-multiselect-target="check" class="h-4 w-4 mr-1 text-green-500 #{'hidden' if !selected}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          <span>#{choice.full_name}</span>
        </div>
      HTML
    end.join

    raw(
      <<-HTML
        <div class="inline-block cursor-pointer relative whitespace-nowrap" data-controller="multiselect" data-multiselect-selected-class="bg-green-50" data-action="click->multiselect#toggle click@window->multiselect#hide">
          #{multi_select_input}
          <div class="inline-flex items-center justify-center w-full rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-indigo-500">
            <span data-multiselect-target="dropdown" class="mr-1">Participants #{selected_choices.length}</span>
            <svg data-multiselect-target="closedIcon" xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-grey-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
            </svg>
            <svg data-multiselect-target="openIcon" xmlns="http://www.w3.org/2000/svg" class="hidden h-4 w-4 text-grey-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
            </svg>
          </div>
          <div data-multiselect-target="options" class="hidden mt-1 pt-1 pb-2 w-48 text-sm bg-white shadow-lg rounded-md absolute origin-top-right right-0 z-50">
            <div>
              #{choices}
            </div>
            <div class="pt-2 mt-1 flex bg-white justify-between">
              <button data-multiselect-target="clearButton" data-action="click->multiselect#deselectAll" class="pl-1 flex items-center hover:text-gray-500">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
                <span>Clear</span>
              </button>
              <button data-multiselect-target="allButton" data-action="click->multiselect#selectAll" class="mr-2 flex items-center hover:text-gray-500">
                <svg class="h-4 w-4 mr-1 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                <span>All</span>
              </button>
            </div>
          </div>
        </div>
      HTML
    )
  end
end

module ApplicationHelper
  def nav_link_to(path)
    classes = if request.path == path
      "bg-gray-900 text-white group flex items-center px-2 py-2 text-sm font-medium rounded-md"
    else
      "text-gray-300 hover:bg-gray-700 hover:text-white group flex items-center px-2 py-2 text-sm font-medium rounded-md"
    end

    link_to(path, class: classes) do
      yield
    end
  end
end
