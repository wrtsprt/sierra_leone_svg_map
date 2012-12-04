require "nokogiri"
require "json"
# require "open-uri"
# url = "http://en.wikipedia.org/wiki/File:Sierra_Leone_location_map.svg"

content = File.read("slmap.svg")
doc = Nokogiri::XML.parse content

def wtf(file_name, content)
  File.open(file_name, 'w') {|f| f.write(content) }
end

######################## polygon ##########################
polygons_array = doc.xpath("//svg:polygon").map do |path_element|
  points  = path_element.attributes['points'].content
  id      = path_element.attributes['id'].content
  style   = path_element.attributes['style'].content

  point_string = "M " + points.split(" ").join(" L ") + " z"
  
  style_hash = {}  
  style.split(";").each do |style_element|
    key, value = style_element.split(":")
    style_hash[key] = value
  end  
  
  {
    path:  point_string,
    id:    id,
    style: style_hash
  }
end

wtf("polygons.json", JSON.generate(polygons_array))

######################### path ##########################
paths_array = doc.xpath("//svg:path").map do |path_element|
  points  = path_element.attributes['d'].content
  id      = path_element.attributes['id'].content
  style   = path_element.attributes['style'].content

  style_hash = {}  
  style.split(";").each do |style_element|
    key, value = style_element.split(":")
    style_hash[key] = value
  end  

  {
    path:  points,
    id:    id,
    style: style_hash
  }
end

wtf("paths.json", JSON.generate(paths_array))

