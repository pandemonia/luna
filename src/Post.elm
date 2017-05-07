module Post exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class, id)


type alias Post =
    { content : String
    , id : Int
    }


createPost : String -> Int -> Post
createPost text id =
    { content = text
    , id = id
    }


showPost : Post -> Html msg
showPost post =
    div
        [ class "post"
        , id <| "post-" ++ toString post.id
        ]
        [ text post.content ]
