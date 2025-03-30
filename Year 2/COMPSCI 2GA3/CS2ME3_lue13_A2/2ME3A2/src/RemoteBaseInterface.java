
public interface RemoteBaseInterface extends EntityObject{
	public void addSpy(SpyInterface s);
	public void removeSpy(SpyInterface s);
	public void printSpies();
	public void goDark();
	public void reconnect();
}
