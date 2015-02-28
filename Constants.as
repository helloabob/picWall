package
{
	import flash.utils.Dictionary;

	public class Constants
	{
		/*0:小图 1:中图 2:大图*/
		public static var runMode:int = 0;
		
		/*大中小图对应-每屏放几行*/
		public static var totalRowsArray:Array = [9,6,2];
		
		/*store image data array*/
		public static var memoryDataArray:Array = [{},{},{}];
		
		/*image height array*/
		public static var imageHeightArray:Array = [120,180,540];
		
//		public static var totalRowsForNormal:int = 9;
//		public static var totalRowsForLarge:int = 2;
		
		public static const horizontalPadding:int = 5;
		public static const verticalPadding:int = 5;
		public static const pixelPerTime:int = 1;
		public static const imageDescription:String = "苏州市公共文化中心是我市重点建设的重大公共文化设施项目和重要的文化标志性工程，于2011年9月正式成立投入使用。是隶属于苏州市文化广电新闻出版局的公益类事业单位。以为市民提供公益性、基本性、均等性、便利性的公共文化服务为宗旨，以保障人民群众享受基本文化权益、参与公共文化生活，完善向社会提供免费文化服务为主要职能。";
		
		public static const smallImageUrl:String = "images/{0}";
		public static const bigImageUrl:String   = "bimages/{0}";
		public static const barcodeUrl:String    = "barcode/{0}";
		
		public static var imageLists:Array = [];
//		public static var imageLists:Array = ["东北大平原.jpg","人体之一.jpg","俄罗斯芭蕾舞.jpg","周矩敏 恒河谣.jpg","冯豪 大地的祝福.jpg","冯豪 山直而逶迤图.JPG","刘懋善 斯皮什堡.jpg","刘懋善 苏州水乡之二（姑苏人家）.JPG","吴雍 夕照山半晴.JPG","吴雍 翠岩锦树.JPG","姚新峰  雪霁.jpg","姚新峰 荷花与鸭（幽禽）.JPG","孙君良 瑞雪启春.JPG","孙君良 花涵清露晓.jpg","孙宽  碧水风荷.JPG","孙宽 清凉.JPG","张明 山花落幽户.jpg","张继馨 早蝉鸣树曲.JPG","张迎春 花鸟之一（霜降）.JPG","张迎春 花鸟之四（春分）.JPG","徐惠泉 人物之一.JPG","徐惠泉 人物之二.JPG","徐源绍  连天白荷 满池香气.jpg","徐源绍 富贵花将墨写神.JPG","杨明义 姑苏屋.JPG","杨明义 江南春早时.JPG","沈宁 凝望.JPG","沈宁 网友.jpg","潘裕钰 水漫金山.JPG","潘裕钰 牡丹倩影图.jpg","马伯乐 一塞秋诗师上迟.JPG","马伯乐 棋声流水古松间.jpg","倒伏人体.jpg","双人体.jpg","嘉陵江畔.jpg","图书馆员.jpg","坐姿背影之一.jpg","坐姿背影之二.jpg","天下奇观海宁潮.jpg","太湖渔船.jpg","太湖风帆.jpg","奥林匹雅.jpg","学员肖像之一.jpg","学员肖像之二.jpg","学生肖像.jpg","家河南望.jpg","少数民族少女.jpg","岩洞.jpg","峡谷余辉.jpg","幽居.jpg","新市水乡.jpg","新疆学员肖像.jpg","春暖鸭先知.jpg","法国时装.jpg","泳池小朋友.jpg","泳装少女.jpg","浮萍.jpg","海带姑娘.jpg","海神.jpg","滑雪.jpg","潮湿的草地 (1).jpg","白床单上的卧女.jpg","相思.jpg","美国老房子.jpg","美的追求.jpg","舒坦.jpg","艳阳.jpg","艾丝米娜达.jpg","苏州大学教学示范之二.jpg","问.jpg","雪景之三.jpg","香格里拉.jpg","黄山少女.jpg","《一串红》36×77.5.JPG","《上海外滩》17.8×26.3.JPG","《上海炼油厂》63.5×101.JPG","《佛罗伦萨广场》23.3×31.1.JPG","《农家乐》42×60.JPG","《初秋》18×26.JPG","《北京人民大会堂》33.8×48.7.JPG","《北京天坛》15.8×17.8.JPG","《北京煤山》17.8×26.JPG","《印度洋夜航》18×26 .JPG","《厨房》50×60.JPG","《国庆十周年》59.4×90.8.JPG","《天鹅湖》28.3×38.JPG","《山居水榭》20×31.8.JPG","《岳父》46×29.5.JPG","《斯里兰卡停泊》18×26.JPG","《旭日照东墙》27×37.5.JPG","《昙花》33×24.JPG","《晨曦》48×35.JPG","《月夜》18×25.8.JPG","《月夜泛舟》48×63.JPG","《杭州保叔塔》18×26.JPG","《杭州六和塔》17.6×25.6.JPG","《杭州疗养所》18×25.9.JPG","《枯树一鸟巢》45.5×60.5.JPG","《沧浪夏夜》34×51.JPG","《沧浪美》64.5×90.4.JPG","《浦江黎明》17.2×24.5.JPG","《石湖串月》48.8×64.5.JPG","《祖姨母》17.6×12.JPG","《秋之诗》33×47.5.JPG","《红海吉布蒂之晨》17.8×26.JPG","《纤侬》43×61.JPG","《罗马海特里安皇陵》18×26.JPG","《苏州双塔》27.5×38.JPG","《苏州拙政园》29×38.JPG","《英国议院》18×26.JPG","《西郊公园早春》27×43.JPG","《轧钢》27.8×35.5.JPG","《远山》18×25.8.JPG","《鸿祥鑫船厂》29.5×38.7.JPG"];
		
		/*store image data*/
//		public static var memoryData:Dictionary = new Dictionary();
//		public static var memoryBigData:Dictionary = new Dictionary();
		
		/*image item height*/
//		public static var smallImageHeight:int = 120;
//		public static var bigImageHeight:int = 540;
		
		/*duration for appearing animation*/
		public static var appearAnimationDuration:int = 2;
		
		public function Constants()
		{
		}
		
		public static function getSmallImageName(imageId:String):String{
			var imgName:String = imageLists[int(imageId)-1];
			return smallImageUrl.replace("{0}",imgName);
		}
		
		public static function getBigImageName(imageId:String):String{
			var imgName:String = imageLists[int(imageId)-1];
			return bigImageUrl.replace("{0}",imgName);
		}
		
		public static function getBarcodeImageName(imageId:String):String{
			var imgName:String = imageLists[int(imageId)-1];
			return barcodeUrl.replace("{0}",imgName);
		}
	}
}