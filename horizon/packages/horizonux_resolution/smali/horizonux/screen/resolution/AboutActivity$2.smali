.class Lhorizonux/screen/resolution/AboutActivity$2;
.super Ljava/lang/Object;
.source "AboutActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lhorizonux/screen/resolution/AboutActivity;->initToolbar()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lhorizonux/screen/resolution/AboutActivity;


# direct methods
.method constructor <init>(Lhorizonux/screen/resolution/AboutActivity;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            "this$0"
        }
    .end annotation

    .line 57
    iput-object p1, p0, Lhorizonux/screen/resolution/AboutActivity$2;->this$0:Lhorizonux/screen/resolution/AboutActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0
        }
        names = {
            "v"
        }
    .end annotation

    .line 60
    iget-object p1, p0, Lhorizonux/screen/resolution/AboutActivity$2;->this$0:Lhorizonux/screen/resolution/AboutActivity;

    invoke-virtual {p1}, Lhorizonux/screen/resolution/AboutActivity;->onBackPressed()V

    return-void
.end method