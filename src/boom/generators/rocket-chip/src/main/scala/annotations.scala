package chisel3.experimental

import chisel3._
import chisel3.experimental.{annotate, ChiselAnnotation}
import firrtl.annotations.{SingleTargetAnnotation, Target}


// NOTE: To be compatible with our "changeAnnoTopModule.py" script, we mark it
//       on the top module, then the script move this annotation to circuit.
case class CircuitIFTConfigAnnotation(target: Target, value: String) extends SingleTargetAnnotation[Target] {
  def duplicate(n: Target) = this.copy(n)
  // iftConfig: PerModule, PerWord, PerBit, Naive, Refined
}

object circuitIFTConfig
{
  def apply(component: Module, value: String): Unit = {
    annotate(new ChiselAnnotation { def toFirrtl = CircuitIFTConfigAnnotation(component.toNamed, value) })
  }
}


case class IFTConfigAnnotation(target: Target, value: String) extends SingleTargetAnnotation[Target] {
  def duplicate(n: Target) = this.copy(n)
  // iftConfig: PerModule, PerWord, PerBit, Naive, Refined
}

object iftConfig
{
  def apply(component: Data, value: String, addDontTouch: Boolean = true): Unit = {
    if (addDontTouch) { dontTouch(component) }
    annotate(new ChiselAnnotation { def toFirrtl = IFTConfigAnnotation(component.toNamed, value) })
  }
  def apply(component: Module, value: String): Unit = {
    annotate(new ChiselAnnotation { def toFirrtl = IFTConfigAnnotation(component.toNamed, value) })
  }
}

