module Main exposing (..)

import Html exposing (Html, button, div, text, input, Attribute)
import Html.Attributes exposing (class, placeholder, value, disabled)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json
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
    | KeyDown Int


model : Model
model =
    Model [] "" 0


pushPost : Model -> Model
pushPost model =
    { model
        | posts = model.posts ++ [ createPost (String.trim model.newPostText) (model.maxId + 1) ]
        , newPostText = ""
        , maxId = model.maxId + 1
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewPostText text ->
            { model | newPostText = text }

        AddPost ->
            pushPost model

        KeyDown keyCode ->
            if keyCode == 13 then
                pushPost model
            else
                model


view : Model -> Html Msg
view model =
    let
        isNewPostInvalid =
            String.length (String.trim model.newPostText) == 0
    in
        div []
            [ div [ class "post-list" ] (List.map showPost model.posts)
            , input
                [ placeholder "Enter some text"
                , onInput NewPostText
                , onKeyDown KeyDown
                , value model.newPostText
                ]
                []
            , button
                [ onClick AddPost
                , disabled isNewPostInvalid
                ]
                [ text "Add" ]
            ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)
