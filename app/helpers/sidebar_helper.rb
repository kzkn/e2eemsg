module SidebarHelper
  def sidebar_items
    [
      { name: :home, label: "Home", href: root_path },
      { name: :user, label: "Users", href: root_path },
      { name: :stamp, label: "Stamp", href: root_path }
    ]
  end
end
