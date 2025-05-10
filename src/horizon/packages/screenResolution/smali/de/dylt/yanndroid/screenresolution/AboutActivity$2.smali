.class Lde/dylt/yanndroid/screenresolution/AboutActivity$2;
.super Ljava/lang/Object;
.source "AboutActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lde/dylt/yanndroid/screenresolution/AboutActivity;->initToolbar()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lde/dylt/yanndroid/screenresolution/AboutActivity;


# direct methods
.method constructor <init>(Lde/dylt/yanndroid/screenresolution/AboutActivity;)V
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
    iput-object p1, p0, Lde/dylt/yanndroid/screenresolution/AboutActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/AboutActivity;

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
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/AboutActivity$2;->this$0:Lde/dylt/yanndroid/screenresolution/AboutActivity;

    invoke-virtual {p1}, Lde/dylt/yanndroid/screenresolution/AboutActivity;->onBackPressed()V

    return-void
.end method
