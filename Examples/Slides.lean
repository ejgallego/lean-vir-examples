/-
Copyright (c) 2026 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Emilio J. Gallego Arias
-/

import Vir

open Lean.Vir.Browser

namespace Examples.Slides

/--
An intentionally abbreviated excerpt for the slide. Keep it focused on the
public VIR workflow instead of mirroring `drawFrame` line for line.
-/
private def sourceExcerpt : String :=
  "@[vir_startup]\n" ++
  "def mount : DomM Unit := do\n" ++
  "  let some root ← Document.querySelector \"#vir-slide-root\"\n" ++
  "    | pure ()\n" ++
  "  let canvasElement ← Document.createElement \"canvas\"\n" ++
  "  Element.appendChild root canvasElement\n" ++
  "  ...\n" ++
  "  let _ ← Animation.requestAnimationFrame (drawFrame ctx status 0)\n\n" ++
  "partial def drawFrame ctx status frame timestamp := do\n" ++
  "  let x := bounceX timestamp\n" ++
  "  CanvasRenderingContext2D.clearRect ctx 0.0 0.0 640.0 360.0\n" ++
  "  CanvasRenderingContext2D.fillRect ctx x 124.0 72.0 72.0\n" ++
  "  let _ ← Animation.requestAnimationFrame\n" ++
  "    (drawFrame ctx status (frame + 1))"

/-- A time-based triangular wave spanning the drawable canvas width. -/
private def bounceX (timestamp : Float) : Float :=
  -- At 250 pixels/second, the rectangle crosses the 568-pixel span in 2272 ms.
  let halfPeriodMs := 2272
  let periodMs := 2 * halfPeriodMs
  let phaseMs := timestamp.toUInt32.toNat % periodMs
  let distanceMs := if phaseMs ≤ halfPeriodMs then phaseMs else periodMs - phaseMs
  Float.scaleB (UInt64.ofNat distanceMs).toFloat (-2)

partial def drawFrame
    (ctx : Lean.Vir.Js CanvasRenderingContext2D)
    (status : Lean.Vir.Js Element)
    (frame : Nat)
    (timestamp : Float) : DomM Unit := do
  let x := bounceX timestamp
  CanvasRenderingContext2D.clearRect ctx 0.0 0.0 640.0 360.0
  CanvasRenderingContext2D.fillRect ctx x 124.0 72.0 72.0
  CanvasRenderingContext2D.strokeRect ctx x 124.0 72.0 72.0
  Element.setTextContent status s!"Lean animation frame: {frame}"
  let _ ← Animation.requestAnimationFrame (drawFrame ctx status (frame + 1))
  pure ()

/-- Builds and starts the example slide's HTML and canvas entirely from Lean. -/
@[vir_startup]
def mount : DomM Unit := do
  match ← Document.querySelector "#vir-slide-root" with
  | none => pure ()
  | some root =>
      Document.setTitle "Lean VIR — Lean-authored slide"
      Element.ClassList.add root "vir-slide"

      let heading ← Document.createElement "h1"
      Element.setTextContent heading "Lean code, live browser"
      Element.appendChild root heading

      let description ← Document.createElement "p"
      Element.ClassList.add description "vir-slide-description"
      Element.setTextContent description
        "The startup hook creates both sides of this slide, then keeps the canvas moving with a Lean callback."
      Element.appendChild root description

      let split ← Document.createElement "div"
      Element.ClassList.add split "vir-slide-grid"
      Element.appendChild root split

      let codePanel ← Document.createElement "section"
      Element.ClassList.add codePanel "vir-slide-code"
      Element.appendChild split codePanel

      let codeLabel ← Document.createElement "p"
      Element.ClassList.add codeLabel "vir-slide-kicker"
      Element.setTextContent codeLabel "LEAN SOURCE · EXCERPT"
      Element.appendChild codePanel codeLabel

      let pre ← Document.createElement "pre"
      let code ← Document.createElement "code"
      Element.setTextContent code sourceExcerpt
      Element.appendChild pre code
      Element.appendChild codePanel pre

      let resultPanel ← Document.createElement "section"
      Element.ClassList.add resultPanel "vir-slide-result"
      Element.appendChild split resultPanel

      let resultLabel ← Document.createElement "p"
      Element.ClassList.add resultLabel "vir-slide-kicker"
      Element.setTextContent resultLabel "RUNNING IN VIR"
      Element.appendChild resultPanel resultLabel

      let resultHeading ← Document.createElement "h2"
      Element.setTextContent resultHeading "Typed DOM and canvas calls"
      Element.appendChild resultPanel resultHeading

      let resultDescription ← Document.createElement "p"
      Element.ClassList.add resultDescription "vir-slide-result-description"
      Element.setTextContent resultDescription
        "JavaScript loads the package and calls runStartupEntries(). The DOM, drawing, and frame loop stay in Lean."
      Element.appendChild resultPanel resultDescription

      let status ← Document.createElement "p"
      Element.ClassList.add status "vir-slide-status"
      Element.setTextContent status "Starting Lean animation…"
      Element.appendChild resultPanel status

      let canvasElement ← Document.createElement "canvas"
      Element.ClassList.add canvasElement "vir-slide-canvas"
      Element.setAttribute canvasElement "role" "img"
      Element.setAttribute canvasElement "aria-label"
        "A purple rectangle bouncing horizontally across a canvas"
      Element.appendChild resultPanel canvasElement
      match ← HTMLCanvasElement.fromElement canvasElement with
      | none => Element.setTextContent status "Lean could not initialize the canvas element"
      | some canvas =>
          HTMLCanvasElement.setWidth canvas 640
          HTMLCanvasElement.setHeight canvas 360
          match ← HTMLCanvasElement.getContext2D canvas with
          | none => Element.setTextContent status "CanvasRenderingContext2D is unavailable"
          | some ctx =>
              CanvasRenderingContext2D.setFillStyle ctx "#5b5bd6"
              CanvasRenderingContext2D.setStrokeStyle ctx "#17172b"
              CanvasRenderingContext2D.setLineWidth ctx 3.0
              let _ ← Animation.requestAnimationFrame (drawFrame ctx status 0)
              pure ()

end Examples.Slides
