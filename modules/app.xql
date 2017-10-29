xquery version "3.0";

module namespace app="http://papyri.uni-koeln.de:8080/exist/apps/Correspondence/templates";

declare namespace tei="http://www.tei-c.org/ns/1.0";
import module namespace util="http://exist-db.org/xquery/util";

declare function app:letterList($node as node(), $module as map(*)) {
    element ul {
        for $object in collection("/db/apps/Correspondence/data")/tei:TEI
        return
            element li {
                element a {
                    attribute href { concat("letter.html?id=", $object/@xml:id) },
                    $object//tei:title/data(.)
                }
            }  
    }
};

declare function app:object() {
    let $id := request:get-parameter("id", ())
    let $object := collection("/db/apps/Correspondence/data")/tei:TEI[@xml:id = $id]
    return $object
};

declare function app:letterTitle($node as node(), $module as map(*)) {
   app:object()//tei:title/data(.)
};

declare function app:letterBy($what as xs:string) {
    app:object()//tei:correspAction[@type=$what]/tei:persName/data(.)
};

declare function app:letterLocation($what as xs:string) {
    app:object()//tei:correspAction[@type=$what]/tei:placeName/data(.)
};

declare function app:letterDate($what as xs:string) {
    app:object()//tei:correspAction[@type=$what]/tei:date/data(.)
};

declare function app:letterSentBy($node as node(), $module as map(*)) {
    app:letterBy("sent")
};

declare function app:letterSentLocation($node as node(), $module as map(*)) {
    app:letterLocation("sent")
};

declare function app:letterSentDate($node as node(), $module as map(*)) {
    app:letterDate("sent")
};

declare function app:letterReceivedBy($node as node(), $module as map(*)) {
    app:letterBy("received")
};

declare function app:letterReceivedLocation($node as node(), $module as map(*)) {
    app:letterLocation("received")
};

declare function app:letterReceivedDate($node as node(), $module as map(*)) {
    app:letterDate("received")
};

declare function app:graph($node as node(), $module as map(*)) {
    element script {
        "var graph = new Springy.Graph();",

        "graph.addNodes(",
        for $name in distinct-values(collection("/db/apps/Correspondence/data")//tei:correspAction/tei:persName/data(.))
        return
            concat("'", $name, "', "),
        ");",
        
        "graph.addEdges(",
        for $object in collection("/db/apps/Correspondence/data")//tei:correspDesc
        return
            (
                "[",
                concat("'", $object/tei:correspAction[@type="sent"]/tei:persName/data(.), "'"),
                ",",
                concat("'", $object/tei:correspAction[@type="received"]/tei:persName/data(.), "'"),
                ", { color: ", concat("'", app:randomColor(), "'"), "}],"
            ),
        ");",

        "jQuery(function() { var springy = jQuery('#graph').springy({ graph }); });"
    }
};

declare function app:randomColor() {
    concat(
        "#",
        util:random(10), util:random(10),
        util:random(10), util:random(10),
        util:random(10), util:random(10)
    )
};