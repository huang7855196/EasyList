import { EasyList } from '../../../../../easyListLibrary/src/main/ets/components//mainpage/EasyList'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      EasyList({
        divider: {
          strokeWidth: 11,
          color: '#fff'
        },
        onRefresh: () => {

        }, listContent: () => {

        } })
    }
    .height('100%')
  }
}