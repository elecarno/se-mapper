
<img src="https://user-images.githubusercontent.com/63984796/201493635-d931c5fc-a7af-411f-9b78-767e5abfc030.png" alt="XMLReader" width="300" align="right"/>

# XMLReader 
A high level class to allow for reading and parsing xml files. xml documents are read into a dictionary and simple find and find_all methods have been implemented.

In the xml dictionary, each node element has `_n` appended to it, where `n` is the n'th occurence starting from 0. Child nodes exist as key/value pairs in the dictionary of their parent node, much like JSON.  Node text is saved as a child of the node as `node_name` + `_text`.  Attributes are saved in a child dict with the `node_name` + `_attrs`, which is a dictionary where each key is an attribute and each value is the value.

## USAGE EXAMPLE
```
const xml_string = "<Entry><DisplayName>ACB_Gamez</DisplayName><Contents><Msg>Hello!</Msg><LastModified>2022-11-10T15:57:51.000Z</LastModified></Contents></Entry>"

var xml = XMLReader.new()
var ERR = xml.open_string(xml_string)
if ERR != OK:
	push_error(ERR)
var path = xml.find_element("Contents_0")
print(xml.prettify("\t", xml.get_element(path)))
```

OUT:
```
{
	"Msg_0": {
		"Msg_0_text": "Hello!"
	},
	"LastModified_0": {
		"LastModified_0_text": "2022-11-10T15:57:51.000Z"
	}
}
```

## DOCUMENTATION
### open_file(file_path:String) -> int:  
*Opens and parses an xml document that is stored in a file at `file_path`. Returns a GlobalScope ERROR value*

### open_buffer(buffer:PoolByteArray) -> int:  
*Opens and parses an xml document that has been loaded into memory as a PoolByteArray. Returns a GlobalScope ERROR value*

### open_string(string:String) -> int:  
*Opens and parses an xml document that has been loaded into memory as a String. Returns a GlobalScope ERROR value*

### parse(parser:XMLParser) -> void:  
*Parses a xml document that has been opened with XMLParser and loads it into a dictionary. This should only be used internally by open_file(), open_buffer(), and open_string(), but can be used if an instance of XMLParser is returned from some exogenous function. Returns a GlobalScope ERROR value*

### get_element(path:Array, dict:Dictionary=xml_dict) -> Dictionary:  
*Returns the dictionary of child nodes of a node at path.*

### find_element(node_name:String) -> PoolStringArray:  
*Returns the path to node_name. If the node does not exist, returns an empty PoolStringArray.*

### find_all_element(node_name:String) -> Array:  
*Returns an array of paths (PoolStringArrays) to all of node_name. for this function, node_name is used without the _integer naming convention. eg, "Contents" will find Contents_0, ...Contents_0+n for as many exist If node_name does not exist, returns and empty Array.*

### find_and_get_element(node_name:String) -> Dictionary:
*A simple helper function for the common use case of finding and getting an element by name.*

### list_nodes() -> Array:
*Returns an array of the node names in the xml document.*

### prettify(delimeter:String="\t", dict:Dictionary=xml_dict) -> String:  
*Returns a "prettified" (readable) string of the xml dictionary. Defaults to using the entire xml document.*


