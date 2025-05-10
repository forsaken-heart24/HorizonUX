.class public Lde/dylt/yanndroid/screenresolution/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"


# static fields
.field public static PREF_NAME:Ljava/lang/String; = "fresh_system_settings"

.field public static RESTRICTED_API:Ljava/lang/String; = "device_restricted_api"

.field public static SCREEN_RESOLUTION:Ljava/lang/String; = "device_screen_resolution"


# instance fields
.field current_resolution:I

.field default_api_setting:I

.field private mContext:Landroid/content/Context;

.field resolution:I

.field private sharedPreferences:Landroid/content/SharedPreferences;


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 28
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lde/dylt/yanndroid/screenresolution/MainActivity;)Landroid/content/SharedPreferences;
    .locals 0

    .line 28
    iget-object p0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->sharedPreferences:Landroid/content/SharedPreferences;

    return-object p0
.end method

.method static synthetic access$100(Lde/dylt/yanndroid/screenresolution/MainActivity;)V
    .locals 0

    .line 28
    invoke-direct {p0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->checkDefaultApiSetting()V

    return-void
.end method

.method static synthetic access$200(Lde/dylt/yanndroid/screenresolution/MainActivity;)Landroid/content/Context;
    .locals 0

    .line 28
    iget-object p0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method static synthetic access$300(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 28
    invoke-static {p0, p1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->setResolution(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private checkDefaultApiSetting()V
    .locals 3

    .line 108
    :try_start_0
    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "hidden_api_policy"

    invoke-static {v0, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->default_api_setting:I

    .line 109
    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->sharedPreferences:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    sget-object v1, Lde/dylt/yanndroid/screenresolution/MainActivity;->RESTRICTED_API:Ljava/lang/String;

    iget v2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->default_api_setting:I

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method private static getWindowManagerService()Ljava/lang/Object;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const-string v0, "android.view.WindowManagerGlobal"

    .line 66
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const/4 v1, 0x0

    new-array v2, v1, [Ljava/lang/Class;

    const-string v3, "getWindowManagerService"

    .line 67
    invoke-virtual {v0, v3, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    .line 68
    invoke-virtual {v0, v2, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0
.end method

.method public static setBypassBlacklist(Landroid/content/Context;Z)V
    .locals 5
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0,
            0x0
        }
        names = {
            "context",
            "bool"
        }
    .end annotation

    const-string v0, "hidden_api_policy"

    const-string v1, "hidden_api_policy_pre_p_apps"

    const-string v2, "hidden_api_policy_p_apps"

    .line 44
    filled-new-array {v0, v1, v2}, [Ljava/lang/String;

    move-result-object v0

    .line 50
    sget-object v1, Lde/dylt/yanndroid/screenresolution/MainActivity;->PREF_NAME:Ljava/lang/String;

    const/4 v2, 0x0

    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 51
    sget-object v3, Lde/dylt/yanndroid/screenresolution/MainActivity;->RESTRICTED_API:Ljava/lang/String;

    invoke-interface {v1, v3, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    const/4 v3, 0x3

    if-eqz p1, :cond_0

    :goto_0
    if-ge v2, v3, :cond_1

    .line 54
    aget-object p1, v0, v2

    .line 55
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const/4 v4, 0x1

    invoke-static {v1, p1, v4}, Landroid/provider/Settings$Global;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    :goto_1
    if-ge v2, v3, :cond_1

    .line 58
    aget-object p1, v0, v2

    .line 59
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    invoke-static {v4, p1, v1}, Landroid/provider/Settings$Global;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    :cond_1
    return-void
.end method

.method private static setResolution(Ljava/lang/String;Ljava/lang/String;)V
    .locals 11
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0,
            0x0
        }
        names = {
            "wmSize",
            "wmDensity"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const-string v0, "reset"

    .line 75
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x3

    const-string v3, "android.view.IWindowManager"

    const/4 v4, 0x2

    const/4 v5, 0x1

    const/4 v6, 0x0

    .line 90
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    if-eqz v1, :cond_0

    .line 76
    invoke-static {v3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    new-array v1, v5, [Ljava/lang/Class;

    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v8, v1, v6

    const-string v8, "clearForcedDisplaySize"

    .line 77
    invoke-virtual {p0, v8, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    .line 78
    invoke-static {}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getWindowManagerService()Ljava/lang/Object;

    move-result-object v1

    new-array v8, v5, [Ljava/lang/Object;

    aput-object v7, v8, v6

    invoke-virtual {p0, v1, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 80
    :cond_0
    new-instance v1, Ljava/util/Scanner;

    invoke-direct {v1, p0}, Ljava/util/Scanner;-><init>(Ljava/lang/String;)V

    const-string p0, "x"

    .line 81
    invoke-virtual {v1, p0}, Ljava/util/Scanner;->useDelimiter(Ljava/lang/String;)Ljava/util/Scanner;

    .line 83
    invoke-virtual {v1}, Ljava/util/Scanner;->nextInt()I

    move-result p0

    .line 84
    invoke-virtual {v1}, Ljava/util/Scanner;->nextInt()I

    move-result v8

    .line 86
    invoke-virtual {v1}, Ljava/util/Scanner;->close()V

    .line 88
    invoke-static {v3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    new-array v9, v2, [Ljava/lang/Class;

    sget-object v10, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v10, v9, v6

    sget-object v10, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v10, v9, v5

    sget-object v10, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v10, v9, v4

    const-string v10, "setForcedDisplaySize"

    .line 89
    invoke-virtual {v1, v10, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 90
    invoke-static {}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getWindowManagerService()Ljava/lang/Object;

    move-result-object v9

    new-array v10, v2, [Ljava/lang/Object;

    aput-object v7, v10, v6

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v10, v5

    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v10, v4

    invoke-virtual {v1, v9, v10}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 93
    :goto_0
    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    const/4 v0, -0x3

    if-eqz p0, :cond_1

    .line 94
    invoke-static {v3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    new-array p1, v4, [Ljava/lang/Class;

    sget-object v1, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v1, p1, v6

    sget-object v1, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v1, p1, v5

    const-string v1, "clearForcedDisplayDensityForUser"

    .line 95
    invoke-virtual {p0, v1, p1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    .line 96
    invoke-static {}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getWindowManagerService()Ljava/lang/Object;

    move-result-object p1

    new-array v1, v4, [Ljava/lang/Object;

    aput-object v7, v1, v6

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v1, v5

    invoke-virtual {p0, p1, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_1

    .line 98
    :cond_1
    invoke-static {p1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0

    .line 100
    invoke-static {v3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    new-array v1, v2, [Ljava/lang/Class;

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v3, v1, v6

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v3, v1, v5

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v3, v1, v4

    const-string v3, "setForcedDisplayDensityForUser"

    .line 101
    invoke-virtual {p1, v3, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p1

    .line 102
    invoke-static {}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getWindowManagerService()Ljava/lang/Object;

    move-result-object v1

    new-array v2, v2, [Ljava/lang/Object;

    aput-object v7, v2, v6

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v2, v5

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v2, v4

    invoke-virtual {p1, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    :goto_1
    return-void
.end method


# virtual methods
.method public initToolbar()V
    .locals 9

    const v0, 0x7f080199

    .line 214
    invoke-virtual {p0, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroidx/appcompat/widget/Toolbar;

    .line 215
    invoke-virtual {p0, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->setSupportActionBar(Landroidx/appcompat/widget/Toolbar;)V

    const v1, 0x7f08004b

    .line 216
    invoke-virtual {p0, v1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Lcom/google/android/material/appbar/AppBarLayout;

    const v2, 0x7f0800a3

    .line 218
    invoke-virtual {p0, v2}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    const v3, 0x7f080071

    .line 219
    invoke-virtual {p0, v3}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    .line 222
    invoke-virtual {v1}, Lcom/google/android/material/appbar/AppBarLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    .line 223
    invoke-virtual {p0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    invoke-virtual {v5}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v5

    iget v5, v5, Landroid/util/DisplayMetrics;->heightPixels:I

    int-to-double v5, v5

    const-wide v7, 0x4004cccccccccccdL    # 2.6

    div-double/2addr v5, v7

    double-to-int v5, v5

    iput v5, v4, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 227
    new-instance v4, Lde/dylt/yanndroid/screenresolution/MainActivity$3;

    invoke-direct {v4, p0, v1, v2, v3}, Lde/dylt/yanndroid/screenresolution/MainActivity$3;-><init>(Lde/dylt/yanndroid/screenresolution/MainActivity;Lcom/google/android/material/appbar/AppBarLayout;Landroid/widget/TextView;Landroid/widget/TextView;)V

    invoke-virtual {v1, v4}, Lcom/google/android/material/appbar/AppBarLayout;->addOnOffsetChangedListener(Lcom/google/android/material/appbar/AppBarLayout$OnOffsetChangedListener;)V

    const/4 v2, 0x0

    .line 235
    invoke-virtual {v1, v2}, Lcom/google/android/material/appbar/AppBarLayout;->setExpanded(Z)V

    .line 239
    new-instance v1, Lde/dylt/yanndroid/screenresolution/MainActivity$4;

    invoke-direct {v1, p0}, Lde/dylt/yanndroid/screenresolution/MainActivity$4;-><init>(Lde/dylt/yanndroid/screenresolution/MainActivity;)V

    invoke-virtual {v0, v1}, Landroidx/appcompat/widget/Toolbar;->setNavigationOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 13
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0
        }
        names = {
            "savedInstanceState"
        }
    .end annotation

    .line 116
    iput-object p0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->mContext:Landroid/content/Context;

    .line 117
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0b001d

    .line 118
    invoke-virtual {p0, p1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->setContentView(I)V

    .line 120
    invoke-virtual {p0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->initToolbar()V

    .line 121
    invoke-virtual {p0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    const v0, 0x7f0f006e

    invoke-virtual {p1, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->settilte(Ljava/lang/String;)V

    .line 123
    sget-object p1, Lde/dylt/yanndroid/screenresolution/MainActivity;->PREF_NAME:Ljava/lang/String;

    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    iput-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->sharedPreferences:Landroid/content/SharedPreferences;

    .line 124
    invoke-direct {p0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->checkDefaultApiSetting()V

    const p1, 0x7f080131

    .line 126
    invoke-virtual {p0, p1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/RadioGroup;

    const v1, 0x7f08012d

    .line 127
    invoke-virtual {p0, v1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Lcom/google/android/material/button/MaterialButton;

    const v9, 0x7f08012f

    .line 128
    invoke-virtual {p0, v9}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    move-object v4, v2

    check-cast v4, Lcom/google/android/material/radiobutton/MaterialRadioButton;

    const v10, 0x7f080130

    .line 129
    invoke-virtual {p0, v10}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    move-object v5, v2

    check-cast v5, Lcom/google/android/material/radiobutton/MaterialRadioButton;

    const v11, 0x7f08012e

    .line 130
    invoke-virtual {p0, v11}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    move-object v6, v2

    check-cast v6, Lcom/google/android/material/radiobutton/MaterialRadioButton;

    .line 132
    iget-object v2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->sharedPreferences:Landroid/content/SharedPreferences;

    sget-object v3, Lde/dylt/yanndroid/screenresolution/MainActivity;->SCREEN_RESOLUTION:Ljava/lang/String;

    invoke-interface {v2, v3, v11}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v2

    iput v2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    const v2, 0x7f080132

    .line 134
    invoke-virtual {p0, v2}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    move-object v8, v2

    check-cast v8, Landroid/widget/TextView;

    .line 136
    new-instance v12, Lde/dylt/yanndroid/screenresolution/MainActivity$1;

    move-object v2, v12

    move-object v3, p0

    move-object v7, v1

    invoke-direct/range {v2 .. v8}, Lde/dylt/yanndroid/screenresolution/MainActivity$1;-><init>(Lde/dylt/yanndroid/screenresolution/MainActivity;Lcom/google/android/material/radiobutton/MaterialRadioButton;Lcom/google/android/material/radiobutton/MaterialRadioButton;Lcom/google/android/material/radiobutton/MaterialRadioButton;Lcom/google/android/material/button/MaterialButton;Landroid/widget/TextView;)V

    invoke-virtual {p1, v12}, Landroid/widget/RadioGroup;->setOnCheckedChangeListener(Landroid/widget/RadioGroup$OnCheckedChangeListener;)V

    .line 162
    iget v2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    packed-switch v2, :pswitch_data_0

    .line 173
    iput v11, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    goto :goto_0

    .line 167
    :pswitch_0
    iput v10, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    goto :goto_0

    .line 170
    :pswitch_1
    iput v9, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    goto :goto_0

    .line 164
    :pswitch_2
    iput v11, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    .line 175
    :goto_0
    iget v2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    iput v2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity;->current_resolution:I

    .line 176
    invoke-virtual {p1, v2}, Landroid/widget/RadioGroup;->check(I)V

    .line 177
    invoke-virtual {v1, v0}, Lcom/google/android/material/button/MaterialButton;->setEnabled(Z)V

    .line 179
    new-instance p1, Lde/dylt/yanndroid/screenresolution/MainActivity$2;

    invoke-direct {p1, p0, v1}, Lde/dylt/yanndroid/screenresolution/MainActivity$2;-><init>(Lde/dylt/yanndroid/screenresolution/MainActivity;Lcom/google/android/material/button/MaterialButton;)V

    invoke-virtual {v1, p1}, Lcom/google/android/material/button/MaterialButton;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void

    :pswitch_data_0
    .packed-switch 0x7f08012e
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public onCreateOptionsMenu(Landroid/view/Menu;)Z
    .locals 2
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0
        }
        names = {
            "menu"
        }
    .end annotation

    .line 257
    invoke-virtual {p0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getMenuInflater()Landroid/view/MenuInflater;

    move-result-object v0

    const/high16 v1, 0x7f0c0000

    invoke-virtual {v0, v1, p1}, Landroid/view/MenuInflater;->inflate(ILandroid/view/Menu;)V

    const/4 p1, 0x1

    return p1
.end method

.method public onOptionsItemSelected(Landroid/view/MenuItem;)Z
    .locals 3
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0
        }
        names = {
            "item"
        }
    .end annotation

    .line 263
    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result v0

    const v1, 0x7f080044

    if-ne v0, v1, :cond_0

    .line 264
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    invoke-virtual {p0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    const-class v2, Lde/dylt/yanndroid/screenresolution/AboutActivity;

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->setClass(Landroid/content/Context;Ljava/lang/Class;)Landroid/content/Intent;

    move-result-object v0

    invoke-virtual {p0, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->startActivity(Landroid/content/Intent;)V

    .line 266
    :cond_0
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onOptionsItemSelected(Landroid/view/MenuItem;)Z

    move-result p1

    return p1
.end method

.method public settilte(Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0
        }
        names = {
            "title"
        }
    .end annotation

    const v0, 0x7f0800a3

    .line 248
    invoke-virtual {p0, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    const v1, 0x7f080071

    .line 249
    invoke-virtual {p0, v1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 250
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 251
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method
