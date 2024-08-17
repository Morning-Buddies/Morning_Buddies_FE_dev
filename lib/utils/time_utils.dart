// 시간 비교 기능 수행
// targetTime 과 현재 시간의 차이를 계산
class TimeUtils {
  static Duration timeUntil(DateTime targetTime) {
    DateTime currentTime = DateTime.now();
    return currentTime.isAfter(targetTime)
        ? Duration.zero
        : targetTime.difference(currentTime); // targetTime 까지 남은 시간
  }
}
