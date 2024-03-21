@Preview
@CustomDialog
@Component
struct LoadingView {
  controller: CustomDialogController
  @State
  num: number = 0
  maxNumber: number = 100
  timer: number = -1
  mWidth: number = 40
  loadingText: string = ''
  aboutToAppear() {
    this.timer = setInterval(() => {
      if(this.num === this.maxNumber) {
        this.num = 0
      }
      this.num++
    }, 10)
  }
  aboutToDisappear() {
    clearInterval(this.timer)
  }
  build() {
    Column({ space: 10 }) {
      Progress({
        value: this.num,
        total: this.maxNumber,
        type: ProgressType.ScaleRing
      }).color($r('app.color.text_secondary'))
        .width(this.mWidth)
        .style({ strokeWidth: 2 })
      if(this.loadingText) {
        Text(this.loadingText)
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
      }
    }
    .alignItems(HorizontalAlign.Center)
  }
}
export { LoadingView }