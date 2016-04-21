class CdjgParser
  class << self
    # 从菜单根节点 zcd: 000000 出发，深度优先遍历获取所有菜单项记录并存为 JSON
    def get_menu_items
      root = Cdjg.menu_root

      progressbar = ProgressBar.create(
        title: "get menu items from root", 
        starting_at: 0, 
        total: Cdjg.count
      )

      data = []
      stack = [{item: root, parent_id: nil}]
      while stack.length > 0
        current = stack.shift
        item = current[:item]
        data.push({id: item.id, parent_id: current[:parent_id]})

        stack = item.children.map { |child|
          {item: child, parent_id: item.id}
        } + stack
        progressbar.increment
      end

      progressbar.progress = Cdjg.count

      puts "got #{data.count} results"

      return data
    end

    def prepare_menu_items(path)
      data = get_menu_items

      progressbar = ProgressBar.create(
        title: "write json", 
        starting_at: 0, 
        total: data.count
      )

      json = data.map { |x|
        id = x[:id]
        parent_id = x[:parent_id]
        progressbar.increment
        Cdjg.find(id).data.merge(
          parent_id: parent_id.to_s
        )
      }.to_json

      File.open path, 'w' do |f|
        f.write json
      end

      puts "written to #{path}"
    end
  end
end