import constants from '../specs/constants.js';

export default {
  checkIsMyHoliday,
  isPast920JST,
};

/**
 * 有休を確認する
 * @returns 有休であるフラグ
 */
async function checkIsMyHoliday() {
  var today = new Date(new Date().toLocaleString("ja-JP", { timeZone: 'Asia/Tokyo' }));

  // 有休
  try {
    const response = await fetch(constants.KTP_MY_HOLIDAYS_URL);
    if (!response.ok) {
      throw new Error(`Response status: ${response.status}`);
    }

    const holidaysStr = await response.text();
    console.log("有休: \n" + holidaysStr);
    var holidays = holidaysStr.split(/\r?\n|\r|\n/g);

    var text = today.toLocaleDateString("ja-JP", { year: "numeric", month: "2-digit", day: "2-digit" });

    var isMyHoliday = holidays.includes(text);
    if (isMyHoliday) {
      console.log("今日は有休です");
    }
    return isMyHoliday;
  } catch (error) {
    console.error(error);
  }

  return false;
}

async function isPast920JST() {
  const now = new Date();

  const tokyoTime = new Date(
    now.toLocaleString("en-US", { timeZone: "Asia/Tokyo" })
  );

  const hours = tokyoTime.getHours();
  const minutes = tokyoTime.getMinutes();

  return hours > 9 || (hours === 9 && minutes >= 20);
}