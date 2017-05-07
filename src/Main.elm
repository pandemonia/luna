module Main exposing (..)

import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (class, placeholder, value, disabled)
import Html.Events exposing (onClick, onInput)
import Post exposing (..)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type alias Model =
    { posts : List Post
    , newPostText : String
    , maxId : Int
    }


type Msg
    = AddPost
    | NewPostText String


model : Model
model =
    { posts = []
    , newPostText = ""
    , maxId = 0
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewPostText text ->
            { model | newPostText = text }

        AddPost ->
            { model
                | posts = model.posts ++ [ createPost (String.trim model.newPostText) (model.maxId + 1) ]
                , newPostText = ""
                , maxId = model.maxId + 1
            }


view : Model -> Html Msg
view model =
    div []
        [ div [ class "post-list" ] (List.map showPost model.posts)
        , input
            [ placeholder "Enter some text"
            , onInput NewPostText
            , value model.newPostText
            ]
            []
        , button
            [ onClick AddPost
            , disabled (not <| isNewPostValid model)
            ]
            [ text "Add" ]
        ]


isNewPostValid : Model -> Bool
isNewPostValid model =
    String.length (String.trim model.newPostText) > 0
