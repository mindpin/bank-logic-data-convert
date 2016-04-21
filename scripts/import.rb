import_data_dir = File.expand_path("../import_data",__FILE__)



items = %w{
  Cdjg
  Hmdy
  Hmzd
  Jyld
  Jyzb
  Jyzd
  Sjzd
  Xxmx
}

hash = {}
items.each do |item|
  json_path = File.join(import_data_dir, "#{item}.json")
  hash[item] = JSON.parse(IO.read(json_path))
end

hash.each do |name, json|
  p "正在导入 #{name}"
  clazz = name.constantize
  clazz.destroy_all

  json.each do |item|
    instance = clazz.new

    item.each do |field_name, value|
      instance.send("#{field_name}=", value)
    end
    instance.save!
  end
end
p "导入完毕"
