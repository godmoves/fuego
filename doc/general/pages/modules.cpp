/** @page generalmodules Module Dependencies

    Libraries are shown in black boxes, applications in blue boxes.

    @dot
    digraph modules
    {
        node [shape=box]

        gtp [label="GtpEngine", color=black]

        sg [label="SmartGame", color=black]
        gtp -> sg

        go [label="Go", color=black]
        sg -> go

        gouct [label="GoUct", color=black]
        go -> gouct

        fuegomain [label="FuegoMain", color=blue]
        gouct -> fuegomain
    }
    @enddot
*/