xquery version "3.0";

module namespace app="http://papyri.uni-koeln.de:8080/exist/apps/Correspondence/templates";

declare namespace tei="http://www.tei-c.org/ns/1.0";
import module namespace util="http://exist-db.org/xquery/util";

declare function app:letterList($node as node(), $module as map(*)) {
    element ul {
        for $object in collection("/db/apps/Correspondence/data/letters")/tei:TEI
        return
            element li {
                element a {
                    attribute href { concat("letter.html?id=", $object/@xml:id) },
                    $object//tei:title/data(.)
                }
            }  
    }
};

declare function app:letter() {
    let $id := request:get-parameter("id", ())
    let $object := collection("/db/apps/Correspondence/data/letters")/tei:TEI[@xml:id = $id]
    return $object
};

declare function app:letterTitle($node as node(), $module as map(*)) {
   app:letter()//tei:title/data(.)
};

declare function app:graph($node as node(), $module as map(*)) {
    element script {
        "var graph = new Springy.Graph();",

        "graph.addNodes(",
        for $name in distinct-values(collection("/db/apps/Correspondence/data/letters")//tei:correspAction/tei:persName/data(.))
        return
            concat("'", $name, "', "),
        ");",
        
        "graph.addEdges(",
        for $object in collection("/db/apps/Correspondence/data/letters")//tei:correspDesc
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

declare function app:letterSender($node as node(), $module as map(*)) {
    app:letterPerson("sent")
};

declare function app:letterReceiver($node as node(), $model as map(*)) {
    app:letterPerson("received")
};

declare function app:letterPerson($what) {
    let $node := app:letter()//tei:correspAction[@type=$what]/tei:persName
    return app:personShort(data($node/@corresp))
};

declare function app:personShort($id) {
    let $person := doc("/db/apps/Correspondence/data/people/people.xml")//tei:person[@xml:id = $id]
    return
        if ($person)
        then
            app:personShortInternal($person)
        else
            "Unknwon person. Please update people.xml!"

};

declare function app:personShortInternal($person) {
    element table {
        
        (: Names :)
        if ($person/tei:persName[@type="main"])
        then
            element tr {
                element td { "Name" },
                element td {
                    element strong {
                        $person/tei:persName[@type="main"]/data(.)
                    }
                }
            }
        else
            (),
            
        if ($person/tei:birth/tei:date)
        then
            element tr {
                element td { "Birth Date" },
                element td {
                    if ($person/tei:birth/tei:date)
                    then
                        element strong { $person/tei:birth/tei:date/data(.) }
                    else
                        ()
                }
            }
        else
            (),
            
        if ($person/tei:birth/tei:placeName)
        then
            element tr {
                element td { "Birth PlaceName" },
                element td {
                    if ($person/tei:birth/tei:placeName)
                    then
                        element strong { $person/tei:birth/tei:placeName/data(.) }
                    else
                        ()
                }
            }
        else
            (),
            
        if ($person/tei:death/tei:date)
        then
            element tr {
                element td { "Death Date" },
                element td {
                    if ($person/tei:death/tei:date)
                    then
                        element strong { $person/tei:death/tei:date/data(.) }
                    else
                        ()
                }
            }
        else
            (),
            
        if ($person/tei:death/tei:placeName)
        then
            element tr {
                element td { "Death PlaceName" },
                element td {
                    if ($person/tei:death/tei:placeName)
                    then
                        element strong { $person/tei:death/tei:placeName/data(.) }
                    else
                        ()
                }
            }
        else
            ()
    },
    
    element a {
        attribute href {
            concat("people.html?id=", $person/@xml:id)
        },
        "See more"
    }
};


declare function app:personInternal($person) {
    element table {
        
        (: Names :)
        for $persName in $person/tei:persName
        return
            element tr {
                element td {
                    if ($persName/@type)
                    then
                        data($persName/@type)
                    else if ($persName/@xml:lang)
                    then
                        ("Name ", data($persName/@xml:lang))
                    else
                        "Name"
                },
                element td {
                    element strong {
                        $persName/data(.)
                    }
                }
            },
            
        if ($person/tei:sex/@value)
        then
            element tr {
                element td { "Sex" },
                element td {
                    element strong {
                        if (data($person/tei:sex/@value) = "F")
                        then
                            "Female"
                        else if (data($person/tei:sex/@value) = "M")
                        then
                            "Male"
                        else
                            data($person/tei:sex/@value)
                    }
                }
            }
        else
            (),
            
        if ($person/tei:socecStatus)
        then
            element tr {
                element td { "Socec Status" },
                element td {
                    element strong { $person/tei:socecStatus }
                }
            }
        else
            (),
            
        if ($person/tei:birth/tei:date)
        then
            element tr {
                element td { "Birth Date" },
                element td {
                    if ($person/tei:birth/tei:date)
                    then
                        element strong { $person/tei:birth/tei:date/data(.) }
                    else
                        ()
                }
            }
        else
            (),
            
        if ($person/tei:birth/tei:placeName)
        then
            element tr {
                element td { "Birth PlaceName" },
                element td {
                    if ($person/tei:birth/tei:placeName)
                    then
                        element strong { $person/tei:birth/tei:placeName/data(.) }
                    else
                        ()
                }
            }
        else
            (),
            
        if ($person/tei:death/tei:date)
        then
            element tr {
                element td { "Death Date" },
                element td {
                    if ($person/tei:death/tei:date)
                    then
                        element strong { $person/tei:death/tei:date/data(.) }
                    else
                        ()
                }
            }
        else
            (),
            
        if ($person/tei:death/tei:placeName)
        then
            element tr {
                element td { "Death PlaceName" },
                element td {
                    if ($person/tei:death/tei:placeName)
                    then
                        element strong { $person/tei:death/tei:placeName/data(.) }
                    else
                        ()
                }
            }
        else
            (),
        
        if ($person/tei:occupation)
        then
            element tr {
                element td { "Occupation" },
                element td {
                    element strong {
                        for $occupation in $person/tei:occupation
                        return ($occupation, " ")
                    }
                }
            }
        else
            (),
            
        
        if ($person/tei:education)
        then
            element tr {
                element td { "Education" },
                element td {
                    element strong { $person/tei:education }
                }
            }
        else
            (),
            
        if ($person/tei:listEvent)
        then
            element tr {
                element td { "Events" },
                element td {
                    for $event in $person/tei:listEvent//tei:event
                    return
                        element p { $event/tei:p }
                }
            }
        else
            (),
            
        if ($person/tei:trait)
        then
            element tr {
                element td { "Trait" },
                element td {
                    element strong {
                        for $trait in $person/tei:trait
                        return ($trait/tei:p/data(.), " ")
                    }
                }
            }
        else
            (),
            
        if ($person/tei:listBibl)
        then
            element tr {
                element td { "Bibliography" },
                element td {
                    for $bibl in $person/tei:listBibl//tei:bibl
                    return
                        element p { $bibl/tei:title/data(.) }
                }
            }
        else
            ()
    }
};

declare function app:letterBody($node as node(), $module as map(*)) {
    transform:transform(app:letter()//tei:text/tei:body, doc("/db/apps/Correspondence/resources/body.xslt"), ())
};


declare function app:person() {
    let $id := request:get-parameter("id", ())
    let $object := doc("/db/apps/Correspondence/data/people/people.xml")//tei:person[@xml:id = $id]
    return $object
};

declare function app:personTitle($node as node(), $module as map(*)) {
    app:person()/tei:persName[@type="main"]/data(.)
};

declare function app:personData($node as node(), $module as map(*)) {
    app:personInternal(app:person())
};