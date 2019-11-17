module Messages exposing (Msg(..), QuizMsg(..))

import Http
import Model


type Msg
    = StartQuiz
    | Quiz QuizMsg
    | GotModel (Result Http.Error Model.Settings)
    | Uploaded (Result Http.Error ())


type QuizMsg
    = Next
    | Answer Int
