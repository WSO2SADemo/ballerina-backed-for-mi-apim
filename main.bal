import ballerina/io;
import ballerina/http;
import ballerina/log;

type Item record {
    string ID = "-1";
    string Title = "-1";
    string Description = "-1";
    string Includes = "-1";
    string IntendedFor = "-1";
    string Color = "-1";
    string Material = "-1";
    float Price = -1.0;
    string sellerId = "-1";
    string departmentName = "-1";
};

type Department record {
    string id = "-1";
    string departmentName = "-1";
    string location = "-1";
    string manager = "-1";
};

type DeliveryStatusItem record {
    int id;
    string itemList;
    string total;
    PurchaseItem[] purchaseItems;
};

type PurchaseItem record {
    string name;
    int quantity;
    float unitPrice;
    float total;
    int delivered;
    int purchaseId;
    int itemId;
};


type InsertExecutionResult record {
    int affectedRowCount;
    int lastInsertId;
};

type Pet record {
    int id = -1;
    string name = "-1";
    string description = "-1";
};

type ErrorRecord record {|
    *http:InternalServerError;
    record {
        string message;
    } body;
|};

service /ecom/rest on new http:Listener(9091) {

    function init() returns error? {
        log:printInfo("Service initialised !");
    }
    
    // for MI integrations
    resource function get items(http:Headers headers, string sellerId) returns Item[]|ErrorRecord {
        io:println("items() called with sellerID: ");
        io:println(sellerId);
        var sellerIdInteger = int:fromString(sellerId);
        if (sellerIdInteger is int) {
            if (sellerIdInteger != -1) {
                return {body: { message: "Exception ocurred when reading sellerId" }};
            }
        } 
        Item[] items = [];
        Item item1 = {ID: "1", Title: "Title1", Description: "Description1", Includes: "Includes1", IntendedFor: "IntendedFor1", Color: "Color1", Material: "Material1", Price: 1.0, sellerId: "1"};
        Item item2 = {ID: "2", Title: "Title2", Description: "Description2", Includes: "Includes2", IntendedFor: "IntendedFor2", Color: "Color2", Material: "Material2", Price: 2.0, sellerId: "2"};
        Item item3 = {ID: "3", Title: "Title3", Description: "Description3", Includes: "Includes3", IntendedFor: "IntendedFor3", Color: "Color3", Material: "Material3", Price: 3.0, sellerId: "3"};
        items.push(item1);
        items.push(item2);
        items.push(item3);
        return items;
    }

    // for APIM backend
    resource function get getPets() returns Pet[] {
        io:println("purchaseItems() called: ");
        Pet[] pets = [];
        // Pet pet = {id: 12, name: "abc", description: "descrption1"};
        pets.push({id: 13, name: "abc", description: "description1"});
        pets.push({id: 14, name: "pqr", description: "description2"});
        io:println(pets);
        return pets;
    }

    resource function get item(string itemId) returns Item|ErrorRecord {
        io:println("item by Id() called: ");
        Item[] items = [];
        Item item1 = {ID: "1", Title: "Title1", Description: "Description1", Price: 1.0, departmentName: "clothing"};
        Item item2 = {ID: "2", Title: "Title2", Description: "Description2", Price: 2.0, departmentName: "kitchen"};
        Item item3 = {ID: "3", Title: "Title3", Description: "Description3", Price: 3.0, departmentName: "vehicle"};
        items.push(item1);
        items.push(item2);
        items.push(item3);
        foreach Item item in items {
            if (item.ID == itemId) {
                return item;
            }
        }  
        ErrorRecord errorResponse = {
            // Populating the fields inherited from `http:InternalServerError`
            body: {
                message: "Item not found."
            }
        };
        return errorResponse;
    }

    resource function get department(string departmentName) returns Department|ErrorRecord {
        io:println("department by name() called: ");
        Department[] items = [];
        Department item1 = {id: "1", departmentName: "clothing", location: "uk", manager: "manager1"};
        Department item2 = {id: "2", departmentName: "kitchen", location: "usa", manager: "manager2"};
        Department item3 = {id: "3", departmentName: "vehicle", location: "japan", manager: "manager3"};
        items.push(item1);
        items.push(item2);
        items.push(item3);
        foreach Department item in items {
            if (item.departmentName == departmentName) {
                return item;
            }
        }  
        ErrorRecord errorResponse = {
            // Populating the fields inherited from `http:InternalServerError`
            body: {
                message: "Department not found."
            }
        };
        return errorResponse;
    }

    resource function post addPet(@http:Payload map<json> mapJson) returns string {
        io:println("addPet() called: ");
        string name = <string>mapJson["name"];
        return "Successfully added the new pet: " + name;
    }

    resource function post addPurchase(@http:Payload map<json> mapJson) returns string {
        io:println("addPurchase() called: ");
        string name = <string>mapJson["name"];
        return "Successfully added the new purchased: " + name;
    }

    resource function post addOrder(@http:Payload map<json> mapJson) returns string {
        io:println("addOrder() called: ");
        return "Successfully added the orders: ";
    }

    resource function get test() returns Pet|ErrorRecord {
        return {id: -1, name: "test", description: "descrption test"};
    }

    resource function get simulateError() returns ErrorRecord {
        ErrorRecord errorResponse = {
            // Populating the fields inherited from `http:InternalServerError`
            body: {
                message: "An unexpected error occurred."
            }
        };
        return errorResponse;
    }
}