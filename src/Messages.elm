module Messages exposing (Msg(..), QuizMsg(..))

import Http


type Msg
    = NoOp
    | Quiz QuizMsg
    | GotText (Result Http.Error String)
    | Reset


type QuizMsg
    = Next
    | Answer Int
