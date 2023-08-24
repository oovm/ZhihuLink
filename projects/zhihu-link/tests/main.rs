use reqwest::Url;
use std::str::FromStr;
use url::Host;
use zhihu_link::{utils::save_string, BilibiliArticle, EMathDissussion, ZhihuAnswer, ZhihuArticle};

#[test]
fn ready() {
    println!("it works!")
}

#[ignore]
#[tokio::test]
async fn export_bilibili() {
    let input = std::fs::read_to_string("test_bilibili.html").unwrap();
    let answer = BilibiliArticle::from_str(&input).unwrap();
    answer.save("tests/bilibili/cv4079473.md").unwrap();
}

#[ignore]
#[tokio::test]
async fn export_emath() {
    let input = std::fs::read_to_string("test_emath_9161.html").unwrap();
    let answer = EMathDissussion::from_str(&input).unwrap();
    answer.save("tests/emath/thread9161.md").unwrap();
    let input = std::fs::read_to_string("test_emath_18664.html").unwrap();
    let answer = EMathDissussion::from_str(&input).unwrap();
    answer.save("tests/emath/thread18664.md").unwrap();
}

#[ignore]
#[tokio::test]
async fn pre_fetch() {
    let answer = ZhihuAnswer::request(347662352, 847873806).await.unwrap();
    save_string("test_answer.html", &answer).unwrap();
    let request = ZhihuArticle::request(438085414).await.unwrap();
    save_string("test_article.html", &request).unwrap();
    let article = BilibiliArticle::request(4079473).await.unwrap();
    save_string("test_bilibili.html", &article).unwrap();
    let article = EMathDissussion::request(9161, 1).await.unwrap();
    save_string("test_emath_9161.html", &article).unwrap();
    let article = EMathDissussion::request(18664, 1).await.unwrap();
    save_string("test_emath_18664.html", &article).unwrap();
}

#[tokio::test]
async fn test_url() {
    // https://www.zhihu.com/question/588042290/answer/2926009682
    // let answer = ZhihuAuto::new("https://www.zhihu.com/question/30928007/answer/1360071170").unwrap();
    // let answer = ZhihuAnswer::new(588042290, 2926009682).await.unwrap();
    // answer.save("test.md").unwrap()
    let answer = ZhihuArticle::new(643912769).await.unwrap();
    answer.save("test.md").unwrap()

    // answer.save("test.md").await.unwrap();
}

#[test]
fn test() {
    let url =
        Url::parse("https://bbs.emath.ac.cn/forum.php?mod=viewthread&tid=5794&page=1#pid55470").expect("failed to parse url");
    println!("{:#?}", url);
    let host = match url.host() {
        Some(Host::Domain(host)) => host,
        _ => panic!("failed to get host"),
    };
    match host {
        "bbs.emath.ac.cn" => println!("emath"),
        _ => println!("others"),
    }
}
