module ApplicationHelper

  def present(object, klass = nil)
    klass ||="#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def currency(number)
    number_to_currency(number)
  end

  def currency_short(number)
    number_to_currency(number, precision: 0)
  end

  def format_date(date)
    date.to_formatted_s(:long)
  end

  def days_from_today (date)
    distance_of_time_in_words(Date.today, date)
  end

  def parsed_tweet(tweet)
    parsed_tweet = tweet.text.dup
    tweet.urls.each do |entity|
      html_link = link_to(entity.display_url.to_s, entity.expanded_url.to_s)
      parsed_tweet.sub!(entity.url.to_s, html_link)
    end
    parsed_tweet.html_safe
  end

  def deactivate_charity_link(charity)
    link_to "Deactivate",
        admin_charity_charity_path(charity.slug, charity,
        :charity => { :status_id => 2}),
        :method => :put,
        :confirm => "Are you sure?",
        class: "btn btn-warning"
  end

  def activate_charity_link(charity)
    link_to "Activate",
        admin_charity_charity_path(charity.slug, charity,
        :charity => { :status_id => 1}),
        :method => :put,
        :confirm => "Are you sure?",
        class: "btn btn-success"
  end

  def suspend_charity_link(charity)
    link_to "Suspend",
        admin_charity_charity_path(charity.slug, charity,
        :charity => { :status_id => 3}),
        :method => :put,
        :confirm => "Are you sure?",
        class: "btn btn-danger"
  end

  def deactivate_need_link(need)
    link_to "Deactivate",
        admin_charity_need_path(need.charity.slug, need,
        :need => { :status_id => 2}),
        :method => :put,
        :confirm => "Are you sure?",
<<<<<<< HEAD
        class: "btn btn-warning"
=======
        class: "btn btn-warning btn-sm"
>>>>>>> 3d03ad3b1043d2ba5376dde51ee830b84b63c19d
  end

  def activate_need_link(need)
    link_to "Activate",
        admin_charity_need_path(need.charity.slug, need,
        :need => { :status_id => 1}),
        :method => :put,
        :confirm => "Are you sure?",
<<<<<<< HEAD
    class: "btn btn-warning"
=======
        class: "btn btn-success btn-sm"
>>>>>>> 3d03ad3b1043d2ba5376dde51ee830b84b63c19d
  end

  def suspend_need_link(need)
    link_to "Suspend",
        admin_charity_need_path(need.charity.slug, need,
        :need => { :status_id => 3}),
        :method => :put,
        :confirm => "Are you sure?",
        class: "btn btn-danger btn-sm"
  end

  def remove_role_link(user, user_role)
    link_to "Delete Role", admin_user_user_role_path(user, user_role), method: :delete
  end

end
