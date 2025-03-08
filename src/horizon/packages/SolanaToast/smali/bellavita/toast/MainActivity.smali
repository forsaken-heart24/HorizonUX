.class public Lbellavita/toast/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"


# direct methods
.method public constructor <init>()V
    .locals 3

    .prologue
    .line 20
    move-object v0, p0

    move-object v2, v0

    invoke-direct {v2}, Landroid/app/Activity;-><init>()V

    return-void
.end method


# virtual methods
.method public onCreate(Landroid/os/Bundle;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/os/Bundle;",
            ")V"
        }
    .end annotation

    .annotation runtime Ljava/lang/Override;
    .end annotation

    .prologue
    move-object v0, p0

    move-object v1, p1

    move-object v4, v0

    invoke-static {v4}, LLogCatBroadcaster;->start(Landroid/content/Context;)V

    .line 14
    move-object v4, v0

    move-object v5, v1

    invoke-super {v4, v5}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 16
    move-object v4, v0

    invoke-virtual {v4}, Lbellavita/toast/MainActivity;->getIntent()Landroid/content/Intent;

    move-result-object v4

    const-string v5, "toasttext"

    invoke-virtual {v4, v5}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    move-object v2, v4

    .line 17
    move-object v4, v2

    if-nez v4, :cond_0

    const-string v4, "ToastText"

    move-object v2, v4

    .line 18
    :cond_0
    move-object v4, v0

    move-object v5, v2

    const/4 v6, 0x1

    invoke-static {v4, v5, v6}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v4

    invoke-virtual {v4}, Landroid/widget/Toast;->show()V

    .line 19
    move-object v4, v0

    invoke-virtual {v4}, Lbellavita/toast/MainActivity;->finish()V

    return-void
.end method
