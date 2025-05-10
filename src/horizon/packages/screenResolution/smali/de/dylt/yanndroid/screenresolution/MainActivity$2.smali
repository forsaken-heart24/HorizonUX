.class Lde/dylt/yanndroid/screenresolution/MainActivity$2;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lde/dylt/yanndroid/screenresolution/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

.field final synthetic val$resolution_apply:Lcom/google/android/material/button/MaterialButton;


# direct methods
.method constructor <init>(Lde/dylt/yanndroid/screenresolution/MainActivity;Lcom/google/android/material/button/MaterialButton;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010
        }
        names = {
            "this$0",
            "val$resolution_apply"
        }
    .end annotation

    .line 179
    iput-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    iput-object p2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->val$resolution_apply:Lcom/google/android/material/button/MaterialButton;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 3
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0
        }
        names = {
            "v"
        }
    .end annotation

    const-string p1, "reset"

    .line 182
    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    invoke-static {v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->access$000(Lde/dylt/yanndroid/screenresolution/MainActivity;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    sget-object v1, Lde/dylt/yanndroid/screenresolution/MainActivity;->SCREEN_RESOLUTION:Ljava/lang/String;

    iget-object v2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    iget v2, v2, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 183
    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->val$resolution_apply:Lcom/google/android/material/button/MaterialButton;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/google/android/material/button/MaterialButton;->setEnabled(Z)V

    .line 184
    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    iget v2, v0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    iput v2, v0, Lde/dylt/yanndroid/screenresolution/MainActivity;->current_resolution:I

    .line 185
    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    invoke-static {v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->access$100(Lde/dylt/yanndroid/screenresolution/MainActivity;)V

    .line 187
    :try_start_0
    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    invoke-static {v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->access$200(Lde/dylt/yanndroid/screenresolution/MainActivity;)Landroid/content/Context;

    move-result-object v0

    const/4 v2, 0x1

    invoke-static {v0, v2}, Lde/dylt/yanndroid/screenresolution/MainActivity;->setBypassBlacklist(Landroid/content/Context;Z)V

    .line 189
    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    iget v0, v0, Lde/dylt/yanndroid/screenresolution/MainActivity;->resolution:I

    packed-switch v0, :pswitch_data_0

    goto :goto_0

    .line 194
    :pswitch_0
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    const v0, 0x7f0f0067

    invoke-virtual {p1, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getString(I)Ljava/lang/String;

    move-result-object p1

    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    const v2, 0x7f0f0066

    invoke-virtual {v0, v2}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->access$300(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 191
    :pswitch_1
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    const v0, 0x7f0f006c

    invoke-virtual {p1, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getString(I)Ljava/lang/String;

    move-result-object p1

    iget-object v0, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    const v2, 0x7f0f006b

    invoke-virtual {v0, v2}, Lde/dylt/yanndroid/screenresolution/MainActivity;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Lde/dylt/yanndroid/screenresolution/MainActivity;->access$300(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 197
    :pswitch_2
    invoke-static {p1, p1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->access$300(Ljava/lang/String;Ljava/lang/String;)V

    .line 202
    :goto_0
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    invoke-static {p1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->access$200(Lde/dylt/yanndroid/screenresolution/MainActivity;)Landroid/content/Context;

    move-result-object p1

    invoke-static {p1, v1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->setBypassBlacklist(Landroid/content/Context;Z)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p1

    const-string v0, "ScreenResolutionService"

    const-string v1, "Fail!"

    .line 205
    invoke-static {v0, v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1
    return-void

    :pswitch_data_0
    .packed-switch 0x7f08012e
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
