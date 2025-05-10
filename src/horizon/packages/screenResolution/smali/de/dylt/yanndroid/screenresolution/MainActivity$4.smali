.class Lde/dylt/yanndroid/screenresolution/MainActivity$4;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lde/dylt/yanndroid/screenresolution/MainActivity;->initToolbar()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;


# direct methods
.method constructor <init>(Lde/dylt/yanndroid/screenresolution/MainActivity;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            "this$0"
        }
    .end annotation

    .line 239
    iput-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$4;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

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

    .line 242
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$4;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    invoke-virtual {p1}, Lde/dylt/yanndroid/screenresolution/MainActivity;->onBackPressed()V

    return-void
.end method
