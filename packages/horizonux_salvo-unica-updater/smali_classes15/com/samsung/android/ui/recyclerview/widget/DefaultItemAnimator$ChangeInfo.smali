.class Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;
.super Ljava/lang/Object;
.source "DefaultItemAnimator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "ChangeInfo"
.end annotation


# instance fields
.field public fromX:I

.field public fromY:I

.field public newHolder:Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;

.field public oldHolder:Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;

.field public toX:I

.field public toY:I


# direct methods
.method private constructor <init>(Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;)V
    .locals 0
    .param p1, "oldHolder"    # Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;
    .param p2, "newHolder"    # Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;

    .line 70
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 71
    iput-object p1, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->oldHolder:Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;

    .line 72
    iput-object p2, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->newHolder:Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;

    .line 73
    return-void
.end method

.method constructor <init>(Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;IIII)V
    .locals 0
    .param p1, "oldHolder"    # Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;
    .param p2, "newHolder"    # Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;
    .param p3, "fromX"    # I
    .param p4, "fromY"    # I
    .param p5, "toX"    # I
    .param p6, "toY"    # I

    .line 76
    invoke-direct {p0, p1, p2}, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;-><init>(Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;)V

    .line 77
    iput p3, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->fromX:I

    .line 78
    iput p4, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->fromY:I

    .line 79
    iput p5, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->toX:I

    .line 80
    iput p6, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->toY:I

    .line 81
    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 2

    .line 85
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ChangeInfo{oldHolder="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->oldHolder:Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", newHolder="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->newHolder:Lcom/samsung/android/ui/recyclerview/widget/SeslRecyclerView$ViewHolder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", fromX="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->fromX:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", fromY="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->fromY:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", toX="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->toX:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", toY="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/samsung/android/ui/recyclerview/widget/DefaultItemAnimator$ChangeInfo;->toY:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const/16 v1, 0x7d

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
