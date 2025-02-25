.class public Lhorizon_ux/system_packages/stub/Stubs$SettingsPrivacyStub;
.super Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;
.source "Stubs.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 123
    invoke-direct {p0}, Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;-><init>()V

    return-void
.end method

.method private hasWorkPolicyInfo()Z
    .locals 4

    const-string v0, "device_policy"

    .line 139
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/admin/DevicePolicyManager;

    .line 141
    invoke-virtual {v0}, Landroid/app/admin/DevicePolicyManager;->getDeviceOwner()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 143
    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.settings.SHOW_WORK_POLICY_INFO"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 144
    invoke-virtual {v2, v0}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v0

    .line 145
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    invoke-virtual {p0, v0, v1}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object p0

    .line 146
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    if-lez p0, :cond_0

    const/4 v1, 0x1

    :cond_0
    return v1
.end method


# virtual methods
.method protected showToastAndFinish()V
    .locals 3

    .line 128
    invoke-virtual {p0}, Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;->showToast()V

    .line 130
    invoke-direct {p0}, Lhorizon_ux/system_packages/stub/Stubs$SettingsPrivacyStub;->hasWorkPolicyInfo()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 131
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v1, "Your work policy info"

    .line 132
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 133
    new-instance v1, Landroid/view/ViewGroup$LayoutParams;

    const/4 v2, -0x2

    invoke-direct {v1, v2, v2}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->addContentView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :cond_0
    return-void
.end method
