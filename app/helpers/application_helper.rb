module ApplicationHelper
  #FIXME only include what is needed
  include WithLinksRendering
  include WithIcons
  include WithNavigation

  def paginate(object, options={})
    "<div class=\"text-center\">#{super(object, {theme: 'twitter-bootstrap-3'}.merge(options))}</div>".html_safe
  end

  def link_to_tag_list(tags)
    tags.map { |tag| link_to "##{tag}", exercises_path(q: tag) }.join(', ').html_safe
  end

  def active_if(expected, current=@current_tab)
    'class="active"'.html_safe if expected == current
  end

  def time_ago_in_words_or_never(date)
    date ? time_ago_in_words(date) : t(:never)
  end

  def tab_list(tabs)
    ('<ul class="nav nav-tabs" role="tablist">' +
        tabs.map do |tab|
%Q{<li role="presentation" class="#{'active' if tab == tabs.first }">
<a href="##{tab}-panel" aria-controls="#{tab}" role="tab" data-toggle="tab">#{t(tab)}</a>
</li>}
        end.join("\n") +
        '</ul>').html_safe
  end

  def next_guides_box(guide, options={})
    return if guide.path.blank?

    suggested = guide.next_guides
    if suggested.empty?
      t :path_finished, path: link_to_path(guide.path)
    else
      link_to t(:next_guide, name: suggested.first.name), suggested.first, class: 'btn btn-success'
    end
  end

  def corollary_box(with_corollary)
    if with_corollary.corollary.present?
      "<div><h3>#{t :corollary}</h3><p>#{with_corollary.corollary_html}</p></div>".html_safe
    end
  end


  def with_classifications(classifiable)
    classifications = [
        (classification_label('success', :certificate, :new) if classifiable.new?),
        (classification_label('info', :university, :learning) if classifiable.learning),
        (classification_label('warning', :warning, :beta) if classifiable.beta)]
    classifications.compact.join(' ').html_safe
  end

  def classification_label(style, icon, key)
    %Q{<span class="label label-#{style}">#{fa_icon icon} #{t key}</span>}
  end

end
