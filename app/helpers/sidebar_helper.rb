module SidebarHelper
  def sidebar_items
    [
      { name: :home, label: "Home", href: root_path },
      { name: :user, label: "Users", href: users_path },
      { name: :stamp, label: "Stamp", href: root_path }
    ]
  end
end
