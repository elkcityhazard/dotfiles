;; extends 
 
((text) @injection.content
 (#match? @injection.content "<.*>")
(#set! injection.language "html")
 (#set! injection.combined)
 (#set! injection.include-children))
        
