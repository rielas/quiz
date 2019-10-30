module Messages exposing (Msg(..), QuizMsg(..))


type Msg
    = NoOp
    | Quiz QuizMsg
    | Reset


type QuizMsg
    = Next
    | Answer Int
