import { LazyDataSource } from '../basic/LazyDataSource'
import vibrator from '@ohos.vibrator'
import { LoadingView } from './LoadingView'

@Component
struct ListView {
  @State
  lazyDataSource: LazyDataSource = new LazyDataSource()
  @State
  refreshIng: boolean = false // 控制下拉刷新
  @State
  loading: boolean = false // 控制上拉加载
  @Prop
  finished: boolean // 是否结束
  @Link
  @Watch('updateDataSource')
  dataSource: object[] // 数据源
  @BuilderParam
  buildItemView: (item: object) => void
  //头布局
  @BuilderParam
  headerView: () => void
  //头布局
  @BuilderParam
  footerView: () => void
  divider: {
    strokeWidth: Length;
    color?: ResourceColor;
    startMargin?: Length;
    endMargin?: Length;
  } | null
  onLoad: () => void = () => {
  } // 上拉加载函数
  onRefresh: () => void = () => {
  } // 下拉刷新函数
  loadingText: string = "加载数据中" // 加载中文本
  finishText: string = "没有内容啦" // 结束文本
  showLoadingIcon: boolean = true // 是否显示加载进度
  updateDataSource() {
    this.lazyDataSource.reloadData(this.dataSource)
  }
  // 获取底部显示的文本
  @Builder
  getBottomDisplay() {
    Row({ space: 10 }) {
      if (this.finished) {
        Text(this.finishText)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
      } else {
        if (this.loading) {
          Text(this.loadingText)
            .fontSize(14)
            .fontColor($r("app.color.text_secondary"))
          if (this.showLoadingIcon) {
            LoadingView({
              mWidth: 20
            })
          }
        }
      }
    }
    .height(50)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Refresh({ refreshing: $$this.refreshIng }) {
      List() {
        if (this.headerView) {
          ListItem() {
            this.headerView
          }
        }
        LazyForEach(this.lazyDataSource, (item: object) => {
          ListItem() {
            if (this.buildItemView) {
              this.buildItemView(item)
            }
          }.width('100%')
        })
        if (this.footerView) {
          ListItem() {
            this.footerView
          }
        }
        ListItem() {
          this.getBottomDisplay()
        }
      }
      .divider(this.divider)
      .onReachEnd(async () => {
        if (!this.finished && !this.loading) {
          this.loading = true
          await this.onLoad()
          this.loading = false
        }
      })
    }
    .onStateChange(async value => {
      if (value === RefreshStatus.Refresh) {
        await this.onRefresh()
        this.refreshIng = false
        this.loading = false
        vibrator.startVibration({ duration: 300, type: 'time' }, { id: 0, usage: 'touch' })
      }
    })
  }
}

export { ListView }