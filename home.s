<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>加载动画 + 玻璃主页</title>
<style>
/* 全局重置 */
* { margin: 0; padding: 0; box-sizing: border-box; }

/* 背景渐变模糊 */
body {
    background: linear-gradient(135deg, #3a7bd5, #00d2ff, #7b4397, #dc2430);
    background-size: 400% 400%;
    animation: bgGradient 12s ease infinite;
    height: 100vh;
    overflow: hidden;
    font-family: 'Arial', sans-serif;
    transition: opacity 0.8s ease;
}

/* 背景渐变动画 */
@keyframes bgGradient {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* 加载动画容器 */
.loader {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 999;
    opacity: 1;
    transition: opacity 1s ease;
}

/* 加载动画圆点 */
.loader .dot {
    width: 20px; height: 20px;
    margin: 0 10px;
    border-radius: 50%;
    background: #fff;
    animation: jump 1.5s infinite ease-in-out;
}

/* 圆点弹跳动画 */
@keyframes jump {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-30px); }
}
.loader .dot:nth-child(2) { animation-delay: 0.2s; }
.loader .dot:nth-child(3) { animation-delay: 0.4s; }

/* 起始页面容器 */
.start-screen {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 100;
    opacity: 1;
    transition: opacity 1.2s ease, transform 1.2s ease;
}

/* 玻璃弹窗通用 */
.glass-card {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(15px);
    -webkit-backdrop-filter: blur(15px);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 24px;
    padding: 40px 60px;
    text-align: center;
}

/* 渐变文字 */
.gradient-text {
    font-size: 36px;
    font-weight: bold;
    background: linear-gradient(90deg, #ff9966, #ff5e62, #833ab4, #fd1d1d, #fcb045);
    background-size: 300% 300%;
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
    animation: textGradient 4s ease infinite;
    cursor: pointer;
    transition: transform 0.2s ease;
}
.gradient-text:active { transform: scale(0.95); }
@keyframes textGradient {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* 状态类：加载完成 */
.started .loader { opacity: 0; pointer-events: none; }
/* 状态类：开始点击后，隐藏起始页 */
.enter-home .start-screen { 
    opacity: 0; 
    pointer-events: none;
    transform: translateY(-50px);
}

/* 主页容器 - 默认隐藏 */
.home-container {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    display: none; /* 关键：默认隐藏，防止直接访问 */
    flex-direction: column;
    z-index: 50;
    color: #fff;
}

/* 显示主页 */
.home-container.show { display: flex; }

/* 顶部导航栏 */
.nav-bar {
    display: flex;
    justify-content: space-around;
    align-items: center;
    height: 70px;
    background: rgba(0, 0, 0, 0.2);
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.nav-item {
    font-size: 18px;
    padding: 10px 20px;
    cursor: pointer;
    border-radius: 20px;
    transition: background 0.3s;
}
.nav-item:hover { background: rgba(255, 255, 255, 0.1); }
.nav-item.active { 
    background: rgba(255, 255, 255, 0.2); 
    font-weight: bold;
}

/* 内容区域 - 占满剩余空间 */
.content-area {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20px;
    overflow: auto;
}

/* 页面内容卡片 */
.page-card {
    background: rgba(0, 0, 0, 0.15);
    border-radius: 20px;
    padding: 40px;
    text-align: center;
    max-width: 600px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.page-card h1 { margin-bottom: 20px; font-size: 28px; }
.page-card p { line-height: 1.6; opacity: 0.9; }

/* 淡出动画类 */
body.fade-out { opacity: 0; }
</style>
</head>
<body>

<!-- 1. 加载动画 -->
<div class="loader">
    <div class="dot"></div>
    <div class="dot"></div>
    <div class="dot"></div>
</div>

<!-- 2. 起始页面 (点击开始前看到的) -->
<div class="start-screen" id="startScreen">
    <div class="glass-card">
        <div class="gradient-text" onclick="enterHome()">开始！</div>
    </div>
</div>

<!-- 3. 主页内容 (点击开始后显示的) -->
<div class="home-container" id="homeContainer">
    <!-- 顶部导航 -->
    <div class="nav-bar">
        <div class="nav-item active" onclick="showPage('home')">主页</div>
        <div class="nav-item" onclick="showPage('about')">关于作者</div>
        <div class="nav-item" onclick="showPage('mine')">我的</div>
    </div>
    
    <!-- 内容区域 -->
    <div class="content-area" id="contentArea">
        <!-- 主页内容 -->
        <div class="page-card" id="page-home">
            <h1>欢迎来到我的主页</h1>
            <p>这是主页面区域。</p>
            <p>在这里你可以展示你的核心内容、作品预览或欢迎信息。</p>
            <p style="margin-top: 20px; opacity: 0.7;">点击上方导航栏查看更多内容。</p>
        </div>

        <!-- 关于作者内容 -->
        <div class="page-card" id="page-about" style="display: none;">
            <h1>关于作者</h1>
            <p>姓名：你的名字</p>
            <p>简介：一名热爱编程与设计的创作者。</p>
            <p>爱好：代码、音乐、旅行与探索。</p>
        </div>

        <!-- 我的内容 -->
        <div class="page-card" id="page-mine" style="display: none;">
            <h1>我的</h1>
            <p>这里是你的个人中心。</p>
            <p>你可以在这里放置：</p>
            <p>个人设置、收藏夹、历史记录或其他专属功能。</p>
        </div>
    </div>
</div>

<script>
// 1. 模拟初始加载
setTimeout(() => {
    document.body.classList.add('started');
}, 2200);

// 2. 点击开始 -> 进入主页 (无跳转)
function enterHome() {
    document.body.classList.add('fade-out');
    setTimeout(() => {
        document.getElementById('homeContainer').classList.add('show');
        document.body.classList.remove('fade-out');
        // 进入主页后，给body加一个类名，用于控制样式
        document.body.classList.add('enter-home');
    }, 800);
}

// 3. 导航栏切换逻辑
let currentPage = 'home';
function showPage(pageName) {
    // 移除所有页面显示
    document.getElementById(`page-${currentPage}`).style.display = 'none';
    // 移除所有active状态
    document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
    
    // 显示新页面
    document.getElementById(`page-${pageName}`).style.display = 'block';
    // 激活当前导航
    document.querySelector(`.nav-item:nth-child(${pageName === 'home' ? 1 : pageName === 'about' ? 2 : 3}`).classList.add('active');
    
    currentPage = pageName;
}

// 4. (可选) 如果需要返回开始界面，可以加一个返回按钮
// 例如在主页卡片里加一个 <div onclick="goToStart()">返回</div>
function goToStart() {
    document.body.classList.add('fade-out');
    setTimeout(() => {
        document.getElementById('homeContainer').classList.remove('show');
        document.body.classList.remove('fade-out', 'enter-home');
    }, 800);
}
</script>

</body>
</html>
