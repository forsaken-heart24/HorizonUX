.class public Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;
.super Landroid/app/Activity;
.source "Stubs.java"


# instance fields
.field private mToast:Landroid/widget/Toast;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 48
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method private cancelToast()V
    .locals 0

    .line 69
    iget-object p0, p0, Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;->mToast:Landroid/widget/Toast;

    if-eqz p0, :cond_0

    .line 70
    invoke-virtual {p0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    return-void
.end method


# virtual methods
.method protected getMessage()Ljava/lang/CharSequence;
    .locals 1

    .line 59
    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const v0, 0x7f010001

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0

    .line 54
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 55
    invoke-virtual {p0}, Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;->showToastAndFinish()V

    return-void
.end method

.method protected showToast()V
    .locals 2

    .line 63
    invoke-direct {p0}, Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;->cancelToast()V

    .line 64
    invoke-virtual {p0}, Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;->getMessage()Ljava/lang/CharSequence;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    iput-object v0, p0, Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;->mToast:Landroid/widget/Toast;

    .line 65
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method protected showToastAndFinish()V
    .locals 0

    .line 75
    invoke-virtual {p0}, Lhorizon_ux/system_packages/stub/Stubs$BaseActivity;->showToast()V

    .line 76
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return-void
.end method
