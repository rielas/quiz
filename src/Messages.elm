module Messages exposing (Msg(..), QuizMsg(..))

import Http
import Model
import Analytics


type Msg
    = StartQuiz
    | Quiz QuizMsg
    | GotModel (Result Http.Error Model.Settings)
    | Measured Analytics.Msg


type QuizMsg
    = Next
    | Answer Int
